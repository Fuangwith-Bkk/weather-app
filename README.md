# Java EE 8 - Weather App
This directory contains an example Java EE 8 app that is used by the Java EE 8 scenarios of learn.openshift.com

## Branches

- master - contains the starting branch for a user
- solution - contains the finished app that they user should end up with after completing the scenarios from learn.openshift.com


## setup database
oc new-app -e POSTGRESQL_USER=weather-app-user -e POSTGRESQL_PASSWORD=secret -e POSTGRESQL_DATABASE=weather-db --name=weather-postgresql postgresql

oc set env dc/weather-app -e DB_SERVICE_PREFIX_MAPPING=weather-postgresql=DB \
  -e DB_JNDI=java:jboss/datasources/WeatherDS \
  -e DB_DATABASE=weather-db \
  -e DB_USERNAME=weather-app-user \
  -e DB_PASSWORD=secret
