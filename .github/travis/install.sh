#!/bin/bash

set -x
set -e

# Add local submodules
.github/add-local-submodules.sh "${TRAVIS_PULL_REQUEST_SLUG:-$TRAVIS_REPO_SLUG}"

# Get a conda environment
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda
source "$HOME/miniconda/etc/profile.d/conda.sh"
hash -r
conda config --set always_yes yes --set changeps1 no

# Uncomment the correct runner
sed -e"s/^#  - $TRAVIS_JOB_NAME$/  - $TRAVIS_JOB_NAME/" -i conf/environment.yml
git diff

conda env create --file conf/environment.yml
conda activate sv-test-env
hash -r
conda info -a

# Generate the tests
make generate-tests
make info

set +e
set +x
