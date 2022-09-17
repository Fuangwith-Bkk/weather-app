#!/bin/sh

oc delete project demo-weather-ci-cd
oc delete project demo-weather-dev
oc delete project demo-weather-prod

