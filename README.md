# deployment-package-example
An example on how to build Kura OSGi projects as Deployment Package.  

After cloning the repository run `./setup-pom.sh` to setup the local target repository and generate the main pom.xml and the webexample pom.xml.

***TO DOs***
* create a git checkout hook to run the setup every time a checkout is performed
* comment the POMs
* build both projects from a single POM, preferably as a Deployment Package

***DONE***
* Build the `webexample` as OSGi bundle containing all resources required to work as a web application
* Package the `webexample` as Deployment Package using a shell script

