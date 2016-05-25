#!/bin/bash

DOWNLOAD_NEEDED=0
TARGET_DIR=/vagrant/sample_data
TARGET_FILE=$TARGET_DIR/1usagov_data.gz
TARGET_UNZIPPED=$TARGET_DIR/1usagov_data
DOMAINS_FILE=$TARGET_DIR/gov_domain_mappings.csv
AGENCY_MAP_FILE=$TARGET_DIR/agency_map
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
    curl -s "https://pycon-2016-tutorial.s3.amazonaws.com/data_checksum" > $CHECKSUM_FILE
    
    shasum -s -a 512 -p -c $CHECKSUM_FILE
    DOWNLOAD_NEEDED=$?
fi

if [ $DOWNLOAD_NEEDED -ne 0 ]; then
    echo "Downloading updated data sample..."
    curl -s "https://pycon-2016-tutorial.s3.amazonaws.com/1usagov_data.gz" > $TARGET_FILE
    echo "Your data sample is now up to date"
else
    echo "Your data sample was alrady up to date."
fi

if [ ! -f $DOMAINS_FILE ]; then
    echo "Downloading government domains mapping file..."
    curl -s "https://pycon-2016-tutorial.s3.amazonaws.com/gov_domain_mappings.csv" > $DOMAINS_FILE
    echo "Mapping file downloaded"
fi

if [ ! -f $AGENCY_MAP_FILE ]; then
    echo "Downloading agency mapping file..."
    curl -s "https://pycon-2016-tutorial.s3.amazonaws.com/agency_map.gz" > "$AGENCY_MAP_FILE.gz"
    gunzip "$AGENCY_MAP_FILE.gz"
    echo "Mapping file downloaded"
fi

echo "Copying your sample data into HDFS..."
zcat $TARGET_FILE > $TARGET_UNZIPPED
head -n 1000 < $TARGET_UNZIPPED > "$TARGET_UNZIPPED$TINY_SUFFIX"
head -n 1000000 < $TARGET_UNZIPPED > "$TARGET_UNZIPPED$SMALL_SUFFIX"
hadoop fs -mkdir -p /user/vagrant/sample_data/
hadoop fs -put -f $TARGET_DIR/1usagov_data* /user/vagrant/sample_data/
hadoop fs -put -f $DOMAINS_FILE /user/vagrant/sample_data
hadoop fs -put -f $AGENCY_MAP_FILE /user/vagrant/sample_data
echo "Sample data uploaded to HDFS, you're good to go!"