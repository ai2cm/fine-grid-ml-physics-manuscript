#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'

EXPERIMENT="ml-on-fine-n2f-prog-rad"
TRIAL="trial-0"
TAG=${EXPERIMENT}-${TRIAL}  # required
NAME="${TAG}-$(openssl rand --hex 2)"

argo submit --from workflowtemplate/prognostic-run \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p config="$(< n2f-run.yaml)" \
    -p memory="18Gi" \
    -p cpu="6" \
    -p segment-count=7 \
    --name "${NAME}" \
    --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"

