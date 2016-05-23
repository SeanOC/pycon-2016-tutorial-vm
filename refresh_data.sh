#!/bin/bash

DOWNLOAD_NEEDED=0
TARGET_DIR=/vagrant/sample_data
TARGET_FILE=$TARGET_DIR/1usagov_data.gz
TARGET_UNZIPPED=$TARGET_DIR/1usagov_data
TINY_SUFFIX="_tiny"
SMALL_SUFFIX="_small"
CHECKSUM_FILE=$TARGET_DIR/data_checksum

mkdir -p $TARGET_DIR
cd $TARGET_DIR

if [ ! -f $TARGET_FILE  ]; then
    echo "No data file found ($TARGET_FILE) ."
    DOWNLOAD_NEEDED=1
else
    echo "Checking if file needs updating."
    curl -s "http://pycon-2016-tutorial.s3.amazonaws.com/data_checksum" > $CHECKSUM_FILE
    
    shasum -s -a 512 -p -c $CHECKSUM_FILE
    DOWNLOAD_NEEDED=$?
fi

if [ $DOWNLOAD_NEEDED -ne 0 ]; then
    echo "Downloading updated data sample..."
    curl -s "http://pycon-2016-tutorial.s3.amazonaws.com/1usagov_data.gz" > $TARGET_FILE
    zcat $TARGET_FILE > $TARGET_UNZIPPED
    head -n 1000 < $TARGET_UNZIPPED > "$TARGET_UNZIPPED$TINY_SUFFIX"
    head -n 1000000 < $TARGET_UNZIPPED > "$TARGET_UNZIPPED$SMALL_SUFFIX"
    echo "Your data sample is now up to date!"
else
    echo "Your data sample was alrady up to date.  You're good to go!"
fi
