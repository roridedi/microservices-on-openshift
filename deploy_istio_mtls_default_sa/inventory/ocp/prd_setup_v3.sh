#!/usr/bin/env bash

APP=inventory
ENV=prd
IMAGE_NAME=${APP}
IMAGE_TAG=0.0.1-SNAPSHOT
SPRING_PROFILES_ACTIVE=v3
VERSION_LABEL=v3
SERVICE_NAME=${APP}-${ENV}

. ../../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc delete deployments ${APP}-${VERSION_LABEL} -n ${PROD_PROJECT}

oc delete configmap ${APP}-${SPRING_PROFILES_ACTIVE}-config --ignore-not-found=true -n ${PROD_PROJECT}
oc create configmap ${APP}-${SPRING_PROFILES_ACTIVE}-config --from-file=config/config.${SPRING_PROFILES_ACTIVE}.properties -n ${PROD_PROJECT}

oc new-app -f ../../spring-boot-prd-deploy-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p IMAGE_NAME=${IMAGE_NAME} \
    -p IMAGE_TAG=${IMAGE_TAG} \
    -p SPRING_PROFILES_ACTIVE=${SPRING_PROFILES_ACTIVE} \
    -p VERSION_LABEL=${VERSION_LABEL}

oc set triggers deployment/${APP}-${VERSION_LABEL} --from-config