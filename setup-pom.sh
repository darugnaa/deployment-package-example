#!/bin/bash

# Configuration variables, can be changed anytime
KURA_ARCHIVE="user_workspace_archive_1.1.1.zip"
KURA_ARCHIVE_URL="https://s3.amazonaws.com/kura_downloads/user_workspace/release/1.1.1/${KURA_ARCHIVE}"
LOCAL_UNZIP_DIR="ws"
SKELETON_POM="pom.skeleton.xml"
FINAL_POM="pom.xml"

#
# Start of the script
#

# Grab the absolute path of this directory
pushd $(dirname $0) > /dev/null
HERE=$(pwd)
popd > /dev/null

# Create the local directory where to download and unzip files
mkdir -p ${HERE}/${LOCAL_UNZIP_DIR} &> /dev/null


#
# 1. Download the kura workspace archive into local directory
#
if [ -f $LOCAL_UNZIP_DIR/$KURA_ARCHIVE ]; then
	echo "Kura archive found."
else
	echo "I will download the Kura workspace archive"
	curl $KURA_ARCHIVE_URL -o ${LOCAL_UNZIP_DIR}/${KURA_ARCHIVE}
	if [ $? -ne 0 ]; then
		echo "Error retrieving file ${KURA_ARCHIVE_URL}"
	fi
	# Would be nice to add some MD5 check
fi


#
# 2. Unzip the archive
#
pushd $LOCAL_UNZIP_DIR > /dev/null
if [ ! -d "target-definition" ]; then
	echo "Uncompressing Kura workspace archive"
	unzip $KURA_ARCHIVE > /dev/null
fi
popd > /dev/null


#
# 3. Sed through the POM skeleton
#    Substitute each occurrence of CLONEPATH in the skeleton with the absolute
#    path to the LOCAL_UNZIP_DIR.
#
if [ ! -f "${SKELETON_POM}" ]; then
	echo "Missing skeleton file: ${SKELETON_POM}"
	exit 1
fi

# Filter main pom
cat ${SKELETON_POM} | sed "s:CLONEPATH:${HERE}/${LOCAL_UNZIP_DIR}:" > $FINAL_POM
echo "$FINAL_POM ready."
