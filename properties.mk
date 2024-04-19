# AOSP
PRODUCT_SYSTEM_EXT_PROPERTIES += \
ro.audio.spatializer_enabled=true \
ro.audio.monitorRotation=true

# Spatial audio
PRODUCT_VENDOR_PROPERTIES += \
vendor.360ra.effect=1

# Dolby
PRODUCT_VENDOR_PROPERTIES += \
ro.vendor.dolby.dax.version=DAX3_3.7.0.8_r1 \
vendor.audio.dolby.ds2.hardbypass=false \
vendor.audio.dolby.ds2.enabled=false
