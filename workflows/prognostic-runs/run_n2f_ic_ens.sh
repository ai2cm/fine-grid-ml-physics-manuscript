#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
IC_TIMESTAMPS="20160805.000000 20160813.000000 20160821.000000 20160829.000000"

for IC in $IC_TIMESTAMPS; do

    EXPERIMENT="ml-on-fine-ic-n2f-${IC}"
    TRIAL="trial-0"
    TAG=${EXPERIMENT}-${TRIAL}  # required
    NAME="${TAG}-$(openssl rand --hex 2)"

    cp n2f-run.yaml n2f-run-compiled.yaml
    yq -yi --arg ic $IC '.initial_conditions.timestep|=$ic' n2f-run-compiled.yaml

    argo submit --from workflowtemplate/prognostic-run \
        -p bucket=${BUCKET} \
        -p project=${PROJECT} \
        -p tag=${TAG} \
        -p config="$(< n2f-run-compiled.yaml)" \
        -p memory="18Gi" \
        -p cpu="6" \
        -p segment-count=2 \
        --name "${NAME}" \
        --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"

done