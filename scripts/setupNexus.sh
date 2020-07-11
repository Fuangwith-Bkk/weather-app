#!/bin/sh

oc new-project demo-nexus --display-name "Nexus"
oc new-app sonatype/nexus3:3.18.1 --name=nexus
oc expose svc nexus
oc rollout pause dc nexus
oc patch dc nexus --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
oc set resources dc nexus --limits=memory=2Gi,cpu=2 --requests=memory=1Gi,cpu=500m
oc set volume dc/nexus --add --overwrite --name=nexus-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc --claim-size=10Gi
oc set probe dc/nexus --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/
oc rollout resume dc nexus

echo "wait until 1/1 pod running then ctrl+c enter"
oc get pods -w

export NEXUS_POD=$(oc get pods | grep nexus | grep -v deploy | awk '{print $1}')
export NEXUS_PASSWORD=$(oc exec $NEXUS_POD -- cat /nexus-data/admin.password)
echo $NEXUS_PASSWORD
echo $NEXUS_PASSWORD > nexus_password.txt

oc set deployment-hook dc/nexus --mid --volumes=nexus-volume-1 \
-- /bin/sh -c "echo nexus.scripts.allowCreation=true >./nexus-data/etc/nexus.properties"

oc rollout latest dc/nexus

echo "wait until 1/1 pod running then ctrl+c enter"
oc get pods -w

curl -o setup_nexus3.sh -s https://raw.githubusercontent.com/redhat-gpte-devopsautomation/ocp_advanced_development_resources/master/nexus/setup_nexus3.sh
chmod +x setup_nexus3.sh
./setup_nexus3.sh admin $NEXUS_PASSWORD http://$(oc get route nexus --template='{{ .spec.host }}')
rm setup_nexus3.sh

oc expose dc nexus --port=5000 --name=nexus-registry
oc create route edge nexus-registry --service=nexus-registry --port=5000

echo "NEXUS URL = $(oc get route nexus -n demo-nexus -o jsonpath='{.spec.host}') "
echo "NEXUS Password = ${NEXUS_PASSWORD}"
echo "login Nexus with admin/${NEXUS_PASSWORD}"
echo "change new password to passw0rd"
echo "enable anonymous access"
