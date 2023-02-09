#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'

EXPERIMENT="ml-on-fine-baseline-long"
TRIAL="trial-0"
TAG=${EXPERIMENT}-${TRIAL}  # required
NAME="${TAG}-$(openssl rand --hex 2)"

argo submit --from workflowtemplate/prognostic-run \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p config="$(< baseline-run.yaml)" \
    -p memory="25Gi" \
    -p cpu="24" \
    -p segment-count=7 \
    --name "${NAME}" \
    --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"
