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
"${CF_CLI}" login \
    -a "${CF_API_URL}" \
    -u "${CF_API_LOGIN}" \
    -p "${CF_API_PASSWORD}" \
    -o system \
    -s system \
    --skip-ssl-validation
"${CF_CLI}" bcr --monthly --ai --si >reports/report.txt

# Setting the timestamp in the filename to make the file unique
# export CURRENT_TIMESTAMP=$(date +"%Y%m%d%H%S")
# mv reports/report.txt reports/bcr-report-$CURRENT_TIMESTAMP.txt
find .

echo
echo -e "\e[33mThe report for this platform is:\e[0m"
# cat reports/bcr-report-$CURRENT_TIMESTAMP.txt
cat reports/report.txt

