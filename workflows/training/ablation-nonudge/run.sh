#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
# TAG is the primary way by which users query for experiments with artifacts
# it determines the output directory for the data

EXPERIMENT="ml-on-fine-res-train-nn-nonudge-rs"
TRIAL="trial-0"
TAG=${EXPERIMENT}-${TRIAL}  # required
NAME=test-train-eval-prog-$(openssl rand --hex 6) # required

argo submit --from workflowtemplate/train-diags-prog \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p training-configs="$( yq . config-model.yaml )" \
    -p training-data-config="$( yq . config-train-data.yaml )" \
    -p test-data-config="$( yq . config-test-data.yaml )" \
    -p validation-data-config="$( yq . config-validation-data.yaml )" \
    -p training-flags="--cache.local_download_path train-data-download-dir" \
    -p prognostic-run-config="$(< prognostic-run.yaml)" \
    -p memory-offline-diags="15Gi" \
    -p cpu-training="7500m" \
    -p memory-training="22Gi" \
    -p public-report-output=gs://vcm-ml-public/offline_ml_diags/$TAG \
    -p do-prognostic-run=false \
    -p segment-count=1 \
    -p wandb-project=fine-res \
    --name "${NAME}" \
    --labels "project=${PROJECT},experiment=${EXPERIMENT},trial=${TRIAL}"
