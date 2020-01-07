#!/bin/bash

# Import certificate and private key
echo $SIGNING_DATA | base64 -d -o Signing.p12
security create-keychain -p ci ci.keychain
security default-keychain -s ci.keychain
security list-keychains -s ci.keychain
security import ./Signing.p12 -k ci.keychain -P $SIGNING_PASSWORD -A
security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k ci ci.keychain
echo $PROFILE_DATA | base64 -d -o Profile.mobileprovision
UUID=`grep UUID -A1 -a Profile.mobileprovision | grep -io "[-A-F0-9]\{36\}"`
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
cp Profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/$UUID.mobileprovision
