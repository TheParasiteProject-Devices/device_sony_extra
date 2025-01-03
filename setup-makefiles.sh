#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
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

function vendor_imports() {
    cat <<EOF >>"$1"
        "hardware/qcom-caf/common/libqti-perfd-client",
        "hardware/qcom-caf/sm8550",
        "hardware/qcom-caf/wlan",
        "hardware/sony",
        "hardware/sony/libidd",
        "vendor/qcom/opensource/commonsys/display",
        "vendor/qcom/opensource/commonsys-intf/display",
        "vendor/qcom/opensource/dataservices",
        "vendor/sony/pdx234",
        "vendor/sony/sm8550-common",
EOF
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt" true
if [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files-carriersettings.txt" ]; then
    write_makefiles "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files-carriersettings.txt"
    write_rro_package "CarrierConfigOverlay" "com.android.carrierconfig" product
    write_single_product_packages "CarrierConfigOverlay"
fi

if [ -f "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-firmware.txt" ]; then
    append_firmware_calls_to_makefiles "${MY_DIR}/proprietary-firmware.txt"
fi

# Finish
write_footers

# Overlays
echo -e "\ninclude vendor/sony/extra/extra/overlays.mk" >> ${PRODUCTMK}
