CI_CD="demo-weather-ci-cd"

oc import-image quay.io/fuangwit/maven36-with-tools:latest --confirm -n ${CI_CD}

oc apply -f manifests/jenkins-configmap.yaml -n ${CI_CD}
oc apply -f manifests/weather-bc-pipeline.yaml -n ${CI_CD}



