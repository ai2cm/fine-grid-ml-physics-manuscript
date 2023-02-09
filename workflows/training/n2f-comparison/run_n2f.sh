#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
# TAG is the primary way by which users query for experiments with artifacts
# it determines the output directory for the data
TAG=ml-on-fine-res-n2f-v1 # required
NAME=${TAG}-$(openssl rand --hex 6)

argo submit --from workflowtemplate/train-diags-prog \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p training-configs="$( yq . training-config.yaml )" \
    -p training-data-config="$( yq . train-n2f.yaml )" \
    -p test-data-config="$( yq . test-n2f.yaml )" \
    -p training-flags="--cache.local_download_path train-data-download-dir" \
    -p cpu-training="7500m" \
    -p memory-training="20Gi" \
    -p wandb-project="fine-res" \
    -p prognostic-run-config="$(< prognostic-run.yaml)" \
    -p public-report-output=gs://vcm-ml-public/offline_ml_diags/$TAG \
    -p segment-count=1 \
    -p do-prognostic-run=false \
    --name "${NAME}"
