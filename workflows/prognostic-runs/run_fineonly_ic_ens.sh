#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
IC_TIMESTAMPS="20160805.000000 20160813.000000 20160821.000000 20160829.000000"
MODEL_URL="gs://vcm-ml-experiments/default/2022-09-20/ml-on-fine-res-train-nn-precip-rs-trial-0/trained_models/model5"

for IC in $IC_TIMESTAMPS; do

    EXPERIMENT="ml-on-fine-ic-prog-${IC}"
    TRIAL="trial-0"
    TAG=${EXPERIMENT}-${TRIAL}  # required
    NAME="${TAG}-$(openssl rand --hex 2)"

    cp prognostic-run.yaml prognostic-run-compiled.yaml
    yq -yi --arg ic $IC '.initial_conditions.timestep|=$ic' prognostic-run-compiled.yaml
    yq -yi --arg url $MODEL_URL '.online_emulator.url[0]|=$url' prognostic-run-compiled.yaml

    argo submit --from workflowtemplate/prognostic-run \
        -p bucket=${BUCKET} \
        -p project=${PROJECT} \
        -p tag=${TAG} \
        -p config="$(< prognostic-run-compiled.yaml)" \
        -p memory="25Gi" \
        -p cpu="24" \
        -p segment-count=2 \
        --name "${NAME}" \
        --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"

done