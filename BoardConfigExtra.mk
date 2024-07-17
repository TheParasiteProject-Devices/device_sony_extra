#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Enable codec support
AUDIO_FEATURE_ENABLED_DS2_DOLBY_DAP := true

# Extra device compatibility matrix
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    device/sony/extra/framework_compatibility_matrix.xml

# Extra sepolicy
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += \
    device/sony/extra/sepolicy/private

BOARD_VENDOR_SEPOLICY_DIRS += \
    device/sony/extra/sepolicy/vendor

include vendor/sony/extra/BoardConfigVendor.mk
