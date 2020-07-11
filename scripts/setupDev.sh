#!/bin/sh

oc new-project dev-weather --display-name "Weather - Dev"

oc policy add-role-to-user edit system:serviceaccount:demo-jenkins:jenkins -n dev-weather

oc apply -f manifests/weather-dc-dev.yaml  -n dev-weather
oc apply -f manifests/weather-svc-dev.yaml  -n dev-weather
oc apply -f manifests/weather-route-dev.yaml  -n dev-weather

