#!/bin/sh

export WEATHER_DEV="demo-weather-dev"
oc new-project ${WEATHER_DEV} --display-name "Weather - Dev"

oc policy add-role-to-user edit system:serviceaccount:demo-jenkins:jenkins -n ${WEATHER_DEV}

oc apply -f manifests/weather-dc-dev.yaml  -n ${WEATHER_DEV}
oc apply -f manifests/weather-svc-dev.yaml  -n ${WEATHER_DEV}
oc apply -f manifests/weather-route-dev.yaml  -n ${WEATHER_DEV}

oc apply -f manifests/weather-is-dev.yaml  -n ${WEATHER_DEV}
oc apply -f manifests/weather-bc-dev.yaml  -n ${WEATHER_DEV}

oc new-app -e POSTGRESQL_USER=weather-app-user -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=weather-db --name=weather-postgresql postgresql -n ${WEATHER_DEV}