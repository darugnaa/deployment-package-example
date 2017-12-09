# deployment-package-example
An example on how to build [Kura] OSGi projects as Deployment Package.  

After cloning the repository run `./setup-pom.sh` (or `.\setup-pom.ps1` from Windows Powershell) to setup the local target repository and generate the main pom.xml. Then invoke Maven `mvn clean verify`. Happy deploy!
Want to reuse your local copy of Kura workspace archive? Copy `pom.skeleton.xml` into `pom.xml` and replace CLONEPATH with your local folder containing the target-definition.

The script requires `unzip` and `curl`. To install them in Ubuntu:

    sudo apt install unzip curl

# Tutorial
This tutorial is about packaging some OSGi bundles into a single Deployment Package. This format is used by Kura to install new bundles at runtime, both locally (via Kura's web interface) and remotely (via MQTT using DEPLOY-V1 cloudlet).
I found no simple guide on how to accomplish this simple task from command line. It took me a while to figure out a way to tell Maven what to do (basically put some jars inside a jar) and I was not alone, other people in Eclipse's forums were searching for the same thing.  


## Getting started
lorem ipsum

## What is a Deployment Package?
A Deployment Package (DP from now on) is just a jar containing a particular MANIFEST plus multiple
bundle jars. The MANIFEST declares names, versions and filenames of included bundles. Each jar is an OSGi bundle.
There are a couple of oddities to be aware of in order to build a Kura-compatible DP.  
1. The order of bundle declarations in the MANIFEST **must be** the same as the order of jars in the zip headers.
2. Only files are allowed in the DP, directories **must not be** included in the DP zip.

Kura uses Felix DeploymentAdmin to handle DPs. Empty directories will result in a null entry in [felix deploymentadmin]. A null entry will raise `"org.osgi.service.deploymentadmin.DeploymentException: Expected more bundles in the stream [...]"`.
Same applies on non-matching file names.

## Maven build walkthrough
lorem ipsum

[Kura]:https://eclipse.org/kura/
[felix deploymentadmin]:https://github.com/apache/felix/blob/b2fbc90c5cbcba405c8392c70c808c02728f6dc1/deploymentadmin/deploymentadmin/src/main/java/org/apache/felix/deploymentadmin/spi/UpdateCommand.java#L60
