#!/bin/bash

set -e

BUCKET=vcm-ml-experiments # don't pass bucket arg to use default 'vcm-ml-experiments'
PROJECT=default # don't pass project arg to use default 'default'
TAG=n2f-prescribe-t-nudge-apparent-sources-only-long # required
NAME="${TAG}-$(openssl rand --hex 6)"

argo submit --from workflowtemplate/prognostic-run \
    -p bucket=${BUCKET} \
    -p project=${PROJECT} \
    -p tag=${TAG} \
    -p config="$(< nudging-config.yaml)" \
    -p segment-count="7" \
    -p memory="24Gi" \
    -p cpu="24" \
    --name "${NAME}"
