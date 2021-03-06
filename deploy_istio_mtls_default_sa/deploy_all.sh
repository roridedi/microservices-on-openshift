#!/usr/bin/env bash

set -x
./prd-setup.sh

oc label namespace amazin-prod istio-injection=enabled

cd user/ocp && ./prd_setup.sh && cd -
cd basket/ocp && ./prd_setup.sh && cd -
cd api-gateway/ocp && ./prd_setup.sh && cd -

cd inventory/ocp && ./prd_setup_v1.sh &&  ./prd_setup_v2.sh && ./prd_setup_v3.sh && cd -

cd istio && ./istio-setup.sh && cd -