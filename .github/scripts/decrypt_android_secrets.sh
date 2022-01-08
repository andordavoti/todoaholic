#! /bin/bash

cd ../../client/android &&
    gpg --output android_keys.zip \
        --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" \
        android_keys.zip.gpg &&
    jar xvf android_keys.zip &&
    mv google-services.json app
