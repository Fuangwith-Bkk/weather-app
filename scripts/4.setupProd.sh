#!/bin/sh

WEATHER_PROD="demo-weather-prod"
WEATHER_DEV="demo-weather-dev"
CICD="demo-weather-ci-cd"

#oc new-project ${WEATHER_PROD} --display-name "Weather - Prod"




#setup blue
oc apply -f manifests/weather-dc-blue.yaml -n ${WEATHER_PROD}
oc apply -f manifests/weather-svc-blue.yaml -n ${WEATHER_PROD}


#setup green
oc apply -f manifests/weather-dc-green.yaml -n ${WEATHER_PROD}
oc apply -f manifests/weather-svc-green.yaml -n ${WEATHER_PROD}


# Expose Green service as route -> Force Green -> Blue deployment on first run
oc apply -f manifests/weather-route-prod.yaml -n ${WEATHER_PROD}

oc new-app -e POSTGRESQL_USER=weather-app-user -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=weather-db --name=weather-postgresql postgresql -n ${WEATHER_PROD}

oc policy add-role-to-group system:image-puller system:serviceaccounts:${WEATHER_PROD} -n ${WEATHER_DEV}
oc policy add-role-to-user edit system:serviceaccount:${CICD}:jenkins -n ${WEATHER_PROD}

oc label dc/weather-postgresql app.kubernetes.io/part-of=Weather-App app.kubernetes.io/name=postgresql -n ${WEATHER_PROD}
oc annotate dc weather-app-blue app.openshift.io/connects-to=weather-postgresql --overwrite  -n ${WEATHER_PROD}
oc annotate dc weather-app-green app.openshift.io/connects-to=weather-postgresql --overwrite  -n ${WEATHER_PROD}