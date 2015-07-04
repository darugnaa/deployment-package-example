# deployment-package-example
An example on how to build [Kura] OSGi projects as Deployment Package.  

After cloning the repository run `./setup-pom.sh` (or `.\setup-pom.ps1` from Windows Powershell) to setup the local target repository and generate the main pom.xml. Then invoke Maven `mvn clean verify`. Happy deploy!

# Tutorial
This tutorial is about packaging some OSGi bundles into a single Deployment Package. This format is used by Kura to install new bundles at runtime, both locally (via Kura's web interface) and remotely (via MQTT using DEPLOY-V1 cloudlet).
I found no simple guide on how to accomplish this simple task from command line. It took me a while to figure out a way to tell Maven what to do (basically put some jars inside a jar) and I was not alone, other people in Eclipse's forums were searching for the same thing.  


## Getting started
lorem ipsum

## What is a Deployment Package?
lorem ipsum

## Maven build walkthrough
lorem ipsum

[Kura]:https://eclipse.org/kura/
