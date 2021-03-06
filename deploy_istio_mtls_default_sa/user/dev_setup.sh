#!/usr/bin/env bash

APP=user
S2I_IMAGE=redhat-openjdk18-openshift:1.4

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${DEV_PROJECT}

oc delete all -l app=${APP} -n ${DEV_PROJECT}
oc delete pvc -l app=${APP} -n ${DEV_PROJECT}
oc delete is,bc,dc,svc,route,sa ${APP} -n ${DEV_PROJECT}
oc delete template ${APP}-dev-dc ${APP}-dev-template -n ${DEV_PROJECT}
oc delete configmap ${APP}-config -n ${DEV_PROJECT}

echo Setting up ${APP} for ${DEV_PROJECT}
oc new-app -f ../../spring-boot-dev-template.yaml \
    -p APPLICATION_NAME=${APP} \
    -p BASE_IMAGE_NAMESPACE="openshift" \
    -p BASE_IMAGE="redhat-openjdk18-openshift:1.4" \
    -n ${DEV_PROJECT}

