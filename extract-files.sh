#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=extra
VENDOR=sony/extra

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

export TARGET_ENABLE_CHECKELF=true

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_FIRMWARE=
KANG=
SECTION=
CARRIER_SKIP_FILES=()

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-firmware)
            ONLY_FIRMWARE=true
            ;;
        -n | --no-cleanup)
            CLEAN_VENDOR=false
            ;;
        -k | --kang)
            KANG="--kang"
            ;;
        -s | --section)
            SECTION="${2}"
            shift
            CLEAN_VENDOR=false
            ;;
        *)
            SRC="${1}"
            ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        product/etc/default-permissions/pre_grant_permissions_oem.xml)
            [ "$2" = "" ] && return 0
            xmlstarlet ed -L --ps -d '//exceptions//exception[@package="com.facebook.appmanager"]' $2
            sed -i '/For docomo/d' $2
            ;;
        product/overlay/*apk)
            [ "$2" = "" ] && return 0
            starletMagic $1 $2 &
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# We don't support firmware
function prepare_firmware() {
    :
}

function starletMagic() {
    folder=${2/.apk/}

    echo "    "${folder##*/} "\\" >> "${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/overlays.mk"

    apktool -q d "$2" -o $folder -f
    rm -rf $2 $folder/{apktool.yml,original,res/values/public.xml,unknown}

    cp ${MY_DIR}/overlay-template.txt $folder/Android.bp
    sed -i "s|dummy|${folder##*/}|g" $folder/Android.bp

    find $folder -type f -name AndroidManifest.xml \
        -exec sed -i "s|extractNativeLibs\=\"false\"|extractNativeLibs\=\"true\"|g" {} \;

    for file in $(find $folder/res -name *xml \
            ! -path "$folder/res/raw" \
            ! -path "$folder/res/drawable*" \
            ! -path "$folder/res/xml"); do
        for tag in $(cat exclude-tag.txt); do
            type=$(echo $tag | cut -d: -f1)
            node=$(echo $tag | cut -d: -f2)
            xmlstarlet ed -L -d "/resources/$type[@name="\'$node\'"]" $file
            xmlstarlet fo -s 4 $file > $file.bak
            mv $file.bak $file
        done
        sed -i "s|\?android:\^attr-private|\@\*android\:attr|g" $file
        sed -i "s|\@android\:color|\@\*android\:color|g" $file
        sed -i "s|\^attr-private|attr|g" $file
    done
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

echo "PRODUCT_PACKAGES += \\" > "${ANDROID_ROOT}/vendor/${VENDOR}/${DEVICE}/overlays.mk"

if [ -z "${ONLY_FIRMWARE}" ]; then
    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

    if [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files-carriersettings.txt" ]; then
        generate_prop_list_from_image "product.img" "${MY_DIR}/../../proprietary-files-carriersettings.txt" CARRIER_SKIP_FILES carriersettings
        extract "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files-carriersettings.txt" "${SRC}" "${KANG}" --section "${SECTION}"
        extract_carriersettings
    fi
fi

if [ -z "${SECTION}" ] && [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" ]; then
    extract_firmware "${MY_DIR}/proprietary-firmware.txt" "${SRC}"
fi

"${MY_DIR}/setup-makefiles.sh"
