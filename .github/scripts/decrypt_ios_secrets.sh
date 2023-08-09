#! /bin/bash

cd ../../client/ios &&
    gpg --output ios_keys.zip \
        --batch --yes --decrypt --passphrase="$IOS_KEYS_SECRET_PASSPHRASE" \
        ios_keys.zip.gpg &&
    jar xvf ios_keys.zip &&
    mv GoogleService-Info.plist Runner
