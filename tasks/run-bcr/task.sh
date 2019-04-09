#!/usr/bin/env bash

set -euo pipefail

BCR_PLUGIN=$(find ./bcr-plugin/bcr-plugin-linux -type f)
if [ -z ${BCR_PLUGIN} ]; then
    echo "Couldn't find the bcr-plugin"
    exit 1
fi

CF_CLI=$(command -v cf)
if [ -z ${CF_CLI} ]; then
    echo "Couldn't find the cf cli"
    exit 1
fi

"${CF_CLI}" install-plugin -f "${BCR_PLUGIN}"
"${CF_CLI}" login -a "${CF_API_URL}" -u "${CF_API_LOGIN}" -p "${CF_API_PASSWORD}" --skip-ssl-validation
"${CF_CLI}" bcr --monthly --ai --si >report/report.txt

cat report/report.txt
