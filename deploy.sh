#!/bin/bash

# Install Tools
npm install -g bower polymer-cli firebase-tools

# For Branch: app-engine 
if [ "$TRAVIS_BRANCH" = "app-engine" ]; then
    # Setup Google Cloud
    openssl aes-256-cbc -K $encrypted_e27920ef8557_key -iv $encrypted_e27920ef8557_iv -in credentials.tar.gz.enc -out credentials.tar.gz -d
    tar -xzf credentials.tar.gz
    mkdir -p lib

    # Install, Setup and Build
    bower install
    npm install
    polymer build

# For Branch: master (Firebase Hosting)
elif [ "$TRAVIS_BRANCH" = "master" ]; then
    # Install, Setup and Build
    bower install
    npm install
    polymer build

    # Deploy to Firebase Hosting
    firebase use default
    firebase deploy --token $FIREBASE_TOKEN --non-interactive --only hosting

# For Branch: october-update (Firebase Hosting)
elif [ "$TRAVIS_BRANCH" = "october-update" ]; then
    # Install, Setup and Build
    cd functions
    bower install
    npm install
    polymer build
    cd ..

    # Deploy to Firebase Hosting and Cloud Functions for Firebase
    firebase use development
    firebase deploy --token $FIREBASE_TOKEN --non-interactive --only hosting,functions
else
   echo "Do Nothing"
fi