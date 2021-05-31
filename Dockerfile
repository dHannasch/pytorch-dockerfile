ARG DOCKER_BASE_IMAGE_PREFIX
ARG DOCKER_BASE_IMAGE_NAMESPACE=pytorch
ARG DOCKER_BASE_IMAGE_NAME=pytorch
ARG DOCKER_BASE_IMAGE_TAG=1.6.0-cuda10.1-cudnn7-runtime
FROM ${DOCKER_BASE_IMAGE_PREFIX}${DOCKER_BASE_IMAGE_NAMESPACE}/${DOCKER_BASE_IMAGE_NAME}:${DOCKER_BASE_IMAGE_TAG}

ARG FIX_ALL_GOTCHAS_SCRIPT_LOCATION
ARG ETC_ENVIRONMENT_LOCATION
ARG CLEANUP_SCRIPT_LOCATION

# Depending on the base image used, we might lack wget/curl/etc to fetch ETC_ENVIRONMENT_LOCATION.
ADD $ETC_ENVIRONMENT_LOCATION ./environment.sh
ADD $FIX_ALL_GOTCHAS_SCRIPT_LOCATION .
ADD $CLEANUP_SCRIPT_LOCATION .

RUN set -o allexport \
    && . ./fix_all_gotchas.sh \
    && set +o allexport \
    && python -c "import torchvision" \
    && python -c "import torchvision.datasets" \
    && python -c "import torchvision.datasets.utils" \
    && python -c "import torchvision.datasets.utils; print(torchvision.datasets.utils.__file__)" \
    && cp torchvision/dataset/utils.py $(python -c "import torchvision.datasets.utils; print(torchvision.datasets.utils.__file__)") \
    && . ./cleanup.sh

