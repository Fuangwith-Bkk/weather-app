#!/bin/sh

oc delete project demo-nexus
oc delete project demo-sonarqube
oc delete project demo-jenkins
oc delete project demo-weather-dev
oc delete project demo-weather-prod

