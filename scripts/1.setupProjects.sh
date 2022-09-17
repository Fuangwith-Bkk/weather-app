#!/bin/sh
echo "Creating Projects ..."
CI_CD=demo-weather-ci-cd
DEV=demo-weather-dev
PROD=demo-weather-prod

oc new-project $DEV  --display-name="Weather - Development Environment"
oc new-project $PROD --display-name="Weather Production Environment"
oc new-project $CI_CD  --display-name="CI/CD Tools"


echo "== Set $DEV,$PROD to pull image from CI_CD =="
oc policy add-role-to-group system:image-puller system:serviceaccounts:${DEV} -n ${CI_CD}
oc policy add-role-to-group system:image-puller system:serviceaccounts:${PROD} -n ${CI_CD}

echo "== Set ${CI_CD} to manage $DEV, $PROD =="
oc policy add-role-to-user edit system:serviceaccount:${CI_CD}:jenkins -n ${DEV}
oc policy add-role-to-user edit system:serviceaccount:${CI_CD}:jenkins -n ${PROD}
