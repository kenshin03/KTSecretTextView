#!/bin/sh
set -e

mkdir -p "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

install_resource()
{
  case $1 in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .storyboard`.storyboardc" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.xib)
        echo "ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile ${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib ${PODS_ROOT}/$1 --sdk ${SDKROOT}"
      ibtool --reference-external-strings-file --errors --warnings --notices --output-format human-readable-text --compile "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$1\" .xib`.nib" "${PODS_ROOT}/$1" --sdk "${SDKROOT}"
      ;;
    *.framework)
      echo "mkdir -p ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      mkdir -p "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync -av ${PODS_ROOT}/$1 ${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      rsync -av "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1"`.mom\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd\""
      xcrun momc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"${PODS_ROOT}/$1\" \"${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm\""
      xcrun mapc "${PODS_ROOT}/$1" "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$1" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ;;
    /*)
      echo "$1"
      echo "$1" >> "$RESOURCES_TO_COPY"
      ;;
    *)
      echo "${PODS_ROOT}/$1"
      echo "${PODS_ROOT}/$1" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
          install_resource "KTSecretTextView/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot1.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot2.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/Screenshots/KTSecretTextView-screenshot3.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/camera_icon.imageset/camera_icon@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/camera_icon.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/Default-568h@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/default_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/default_texture.imageset/default_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/LaunchImage.launchimage/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/LaunchImage.launchimage/Default-568h@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/linen_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/linen_texture.imageset/linen_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/lines_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/lines_texture.imageset/lines_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/noise_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/noise_texture.imageset/noise_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squared_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squared_texture.imageset/squared_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squares2_texture.imageset/Contents.json"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squares2_texture.imageset/squares2_texture@2x.png"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/camera_icon.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/default_texture.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/LaunchImage.launchimage"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/linen_texture.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/lines_texture.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/noise_texture.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squared_texture.imageset"
                    install_resource "KTSecretTextView/SecretTextView/Resources/SecretTextImages.xcassets/squares2_texture.imageset"
          
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]]; then
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ `find . -name '*.xcassets' | wc -l` -ne 0 ]
then
  case "${TARGETED_DEVICE_FAMILY}" in
    1,2)
      TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
      ;;
    1)
      TARGET_DEVICE_ARGS="--target-device iphone"
      ;;
    2)
      TARGET_DEVICE_ARGS="--target-device ipad"
      ;;
    *)
      TARGET_DEVICE_ARGS="--target-device mac"
      ;;
  esac
  find "${PWD}" -name "*.xcassets" -print0 | xargs -0 actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${IPHONEOS_DEPLOYMENT_TARGET}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
