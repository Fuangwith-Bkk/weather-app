#!/bin/sh

export WEATHER_PROD="demo-weather-prod"
oc new-project ${WEATHER_PROD} --display-name "Weather - Prod"

oc policy add-role-to-group system:image-puller system:serviceaccounts:weather-prod -n ${WEATHER_PROD}
oc policy add-role-to-user edit system:serviceaccount:demo-jenkins:jenkins -n ${WEATHER_PROD}