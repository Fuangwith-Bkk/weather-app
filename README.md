# Java EE 8 - Weather App
The 'code' directory contains an example Java EE 8 app that is used by the Java EE 8 scenarios of learn.openshift.com

# Environment Setup
## Request Environment
- request OpenShift 4.4 workshop from RHPDS

## login
export GUID=<GUID>
oc login -u opentlc-mgr https://api.cluster-${GUID}.${GUID}.example.opentlc.com:6443

## create demo resources
cd weather-app/scripts
./setupJenkins.sh

test login Jenkins

./setupNexus.sh
login Nexus with admin/<generated password>
change new password to passw0rd
enable anonymous access

./setupSonarQube.sh
test login Sonar Qube

./setupDev.sh
./setupProd.sh