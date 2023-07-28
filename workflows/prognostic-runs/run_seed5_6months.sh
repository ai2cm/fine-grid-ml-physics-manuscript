#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
RANDOM_SEED=5

MODEL_URL="gs://vcm-ml-experiments/default/2022-09-20/ml-on-fine-res-train-nn-precip-rs-trial-0/trained_models/model${RANDOM_SEED}"
EXPERIMENT="ml-on-fine-ensemble-prog-rad-vl-${RANDOM_SEED}"
TRIAL="trial-0"
TAG=${EXPERIMENT}-${TRIAL}  # required
NAME="${TAG}-$(openssl rand --hex 2)"

cp prognostic-run.yaml prognostic-run-compiled.yaml
yq -yi --arg url $MODEL_URL '.online_emulator.url[0]|=$url' prognostic-run-compiled.yaml
yq -yi 'del(.prephysics[0])' prognostic-run-compiled.yaml

argo submit --from workflowtemplate/prognostic-run \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p config="$(< prognostic-run-compiled.yaml)" \
    -p memory="25Gi" \
    -p cpu="24" \
    -p segment-count=36 \
    --name "${NAME}" \
    --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"
