#!/usr/bin/env bash

#set -x

APP=web
S2I_IMAGE=nginx:1.10

. ../../env.sh

oc login https://${IP}:8443 -u $USER

oc project ${PROD_PROJECT}

oc delete all -l app=${APP} -n ${PROD_PROJECT}
oc delete pvc -l app=${APP} -n ${PROD_PROJECT}
oc delete bc,dc,svc,route ${APP} -n ${PROD_PROJECT}
oc delete template ${APP}-prod-dc -n ${PROD_PROJECT}
oc delete configmap ${APP}-config -n ${PROD_PROJECT}

echo Setting up ${APP} for ${PROD_PROJECT}
oc new-app -f ./${APP}-prod-pod.yaml --allow-missing-imagestream-tags=true -n ${PROD_PROJECT}

