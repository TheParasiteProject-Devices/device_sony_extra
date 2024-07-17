# Added system property for RID009076
PRODUCT_SYSTEM_PROPERTIES += \
persist.vendor.automaster.mode=true
persist.vendor.colorgamut.current.mode=1
persist.vendor.reduce_afterimage.mode=false

# AOSP
PRODUCT_SYSTEM_EXT_PROPERTIES += \
ro.audio.spatializer_enabled=true \
ro.audio.monitorRotation=true

# Spatial audio
PRODUCT_VENDOR_PROPERTIES += \
vendor.360ra.effect=1

# Display(RID012364)
PRODUCT_SYSTEM_PROPERTIES += \
persist.vendor.display.dynamic_tone_mapping.mode=true

# Dolby
PRODUCT_VENDOR_PROPERTIES += \
ro.vendor.dolby.dax.version=DAX3_3.7.0.8_r1 \
vendor.audio.dolby.ds2.hardbypass=false \
vendor.audio.dolby.ds2.enabled=true

# Enable Color-Gamut
PRODUCT_SYSTEM_PROPERTIES += \
ro.sys.colorgamut.supported=true
persist.vendor.colorgamut.mode=1

# X1 default setting
PRODUCT_SYSTEM_PROPERTIES += \
persist.service.xrfm.mode=1

# Media Vibration
PRODUCT_SYSTEM_PROPERTIES += \
ro.somc.media_vibration.supported=true
