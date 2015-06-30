@echo off
REM Configuration variables, can be changed anytime
set KURA_ARCHIVE=user_workspace_archive_1.2.0.zip
set KURA_ARCHIVE_URL=https://s3.amazonaws.com/kura_downloads/user_workspace/release/1.2.0/%KURA_ARCHIVE%
set "LOCAL_UNZIP_DIR=ws\"
set SKELETON_POM="pom.skeleton.xml"
set FINAL_POM="pom.xml"

REM
REM Start of the script
REM

REM Grab the absolute path of this directory
set HERE=%~dp0

REM Create the local directory where to download and unzip files
mkdir %HERE%%LOCAL_UNZIP_DIR% 2> nul

REM
REM 1. Download the kura workspace archive into local directory
REM
if exist %LOCAL_UNZIP_DIR%%KURA_ARCHIVE% (
	echo "Kura archive found."
) else (
	echo "I will download the Kura workspace archive"
	REM bitsadmin need absolute paths
	bitsadmin.exe /transfer "KuraDownload" %KURA_ARCHIVE_URL% %HERE%%LOCAL_UNZIP_DIR%%KURA_ARCHIVE%
)


REM
REM 2. Unzip the archive
REM
pushd %LOCAL_UNZIP_DIR% > nul
if not exist target-definition (
	echo "Uncompressing Kura workspace archive"
	7za x %KURA_ARCHIVE%
)
popd > nul


REM
REM 3. Sed through the POM skeleton
REM    Substitute each occurrence of CLONEPATH in the skeleton with the absolute
REM    path to the LOCAL_UNZIP_DIR.
REM
if not exist %SKELETON_POM% (
	echo "Missing skeleton file: %SKELETON_POM%"
	exit 1
)
@echo on