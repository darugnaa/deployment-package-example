#!/bin/bash
echo "Compiling with Maven"
mvn clean verify

echo "Creating Deployment Package"

mkdir -p dpp-temp/bundles
mkdir -p dpp-temp/META-INF

cp target/org.darugna.alessandro.webexample-1.0.0.jar dpp-temp/bundles/

pushd dpp-temp
echo "Manifest-Version: 1.0" >> META-INF/MANIFEST.MF
echo "DeploymentPackage-SymbolicName: webexample" >> META-INF/MANIFEST.MF
echo "DeploymentPackage-Version: 1.0.0.SNAPSHOT" >> META-INF/MANIFEST.MF
echo "" >> META-INF/MANIFEST.MF
echo "Name: bundles/org.darugna.alessandro.webexample-1.0.0.jar" >> META-INF/MANIFEST.MF
echo "Bundle-SymbolicName: org.darugna.alessandro.webexample;singleton:=true" >> META-INF/MANIFEST.MF
echo "Bundle-Version: 1.0.0" >> META-INF/MANIFEST.MF

zip webexample.dpp META-INF/MANIFEST.MF
zip webexample.dpp bundles/org.darugna.alessandro.webexample-1.0.0.jar
popd
cp dpp-temp/webexample.dpp .

rm -rf dpp-temp
