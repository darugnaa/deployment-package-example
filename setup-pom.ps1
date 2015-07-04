# Configuration variables, can be changed anytime
Set-Variable KURA_ARCHIVE user_workspace_archive_1.2.0.zip
Set-Variable KURA_ARCHIVE_URL https://s3.amazonaws.com/kura_downloads/user_workspace/release/1.2.0/$KURA_ARCHIVE
Set-Variable LOCAL_UNZIP_DIR ws
Set-Variable SKELETON_POM pom.skeleton.xml
Set-Variable FINAL_POM pom.xml

#
# Start of the script
#

# Grab the absolute path of this directory
Set-Variable HERE (Get-Item -Path ".\" -Verbose).FullName
Write-Host "Working in directory $HERE"

# Create the local directory where to download and unzip files
New-Item -ItemType directory -Path  $HERE\$LOCAL_UNZIP_DIR -Force | out-null

#
# 1. Download the kura workspace archive into local directory
#
If (Test-Path $HERE\$LOCAL_UNZIP_DIR\$KURA_ARCHIVE) {
	Write-Host "Kura archive found."
} Else {
	echo "I will download the Kura workspace archive"
	$client = new-object System.Net.WebClient
	$client.DownloadFile("$KURA_ARCHIVE_URL", "$HERE\$LOCAL_UNZIP_DIR\$KURA_ARCHIVE")
}



#
# 2. Unzip the archive
# http://www.howtogeek.com/tips/how-to-extract-zip-files-using-powershell/
#
pushd $HERE\$LOCAL_UNZIP_DIR | out-null
If (Test-Path target-definition) {
	Write-Host Kura target-definition directory found
} Else {
	Write-Host "Uncompressing Kura workspace archive"
	$shell = new-object -com shell.application
	$zip = $shell.NameSpace("$HERE\$LOCAL_UNZIP_DIR\$KURA_ARCHIVE")
	foreach($item in $zip.items())
	{
		$shell.Namespace("$HERE\$LOCAL_UNZIP_DIR").copyhere($item)
	}
}
popd | out-null


#
# 3. Sed through the POM skeleton
#    Substitute each occurrence of CLONEPATH in the skeleton with the absolute
#    path to the LOCAL_UNZIP_DIR.
#
If (-Not (Test-Path $SKELETON_POM)) {
	Write-Host "Missing skeleton file: $SKELETON_POM"
	exit 1
}

# stackoverflow.com/questions/127318/is-there-any-sed-like-utility-for-cmd-exe
Write-Host "Preparing main POM"
get-content $SKELETON_POM | %{$_ -replace "CLONEPATH","$HERE\$LOCAL_UNZIP_DIR"} | Out-File -Encoding "UTF8" pom.xml

#Write-Host "Preparing example POM"
#get-content org.darugna.alessandro.example\$SKELETON_POM | %{$_ -replace "CLONEPATH","$HERE\$LOCAL_UNZIP_DIR"} | Out-File -Encoding "UTF8" org.darugna.alessandro.example\pom.xml