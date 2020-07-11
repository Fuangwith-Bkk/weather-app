#!/bin/sh

oc new-project dev-weather --display-name "Weather - Dev"

oc policy add-role-to-user edit system:serviceaccount:demo-jenkins:jenkins -n dev-weather

oc apply -f manifests/weather-dc-dev.yaml  -n dev-weather
oc apply -f manifests/weather-svc-dev.yaml  -n dev-weather
oc apply -f manifests/weather-route-dev.yaml  -n dev-weather

oc apply -f manifests/weather-is-dev.yaml  -n dev-weather
oc apply -f manifests/weather-bc-dev.yaml  -n dev-weather

oc new-app -e POSTGRESQL_USER=weather-app-user -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=weather-db --name=weather-postgresql postgresql -n dev-weather