#!/bin/bash

VERSION=$(cat Launchster.xcodeproj/project.pbxproj | \
          grep -m1 'MARKETING_VERSION' | cut -d'=' -f2 | \
          tr -d ';' | tr -d ' ')
ARCHIVE_DIR=/Users/Larry/Library/Developer/Xcode/Archives/CommandLine

rm -f make.log
touch make.log
rm -rf build

echo "Building Launchster" 2>&1 | tee -a make.log

xcodebuild -project Launchster.xcodeproj clean 2>&1 | tee -a make.log
xcodebuild -project Launchster.xcodeproj \
    -scheme "Launchster Release" -archivePath Launchster.xcarchive \
    archive 2>&1 | tee -a make.log

rm -rf ${ARCHIVE_DIR}/Launchster-v${VERSION}.xcarchive
cp -rf Launchster.xcarchive \
    ${ARCHIVE_DIR}/Launchster-v${VERSION}.xcarchive

