#! /bin/bash

gpg --output ../../client/android/android_keys.zip --batch --yes --decrypt --passphrase="$ANDROID_KEYS_SECRET_PASSPHRASE" ../../client/android/android_keys.zip.gpg && jar xvf ../../client/android/android_keys.zip && mv ../../client/android/google-services.json ../../client/android/app
