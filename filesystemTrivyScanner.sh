#!/bin/bash
source functions.sh
source log-functions.sh
cd  "${WORKSPACE}"/"${CODEBASE_DIR}"

if [ -d "reports" ]; then
    true
else
    mkdir reports
fi

STATUS=0

if [ -n "${SCAN_TYPE}" ]; then
    echo "SCAN_TYPE is ${SCAN_TYPE}"
else
    echo "SCAN_TYPE is not found "
    exit 1
fi

    logInfoMessage "I'll scan file in ${WORKSPACE}/${CODEBASE_DIR} for only ${SCAN_SEVERITY} severities"
    sleep  "$SLEEP_DURATION"
    logInfoMessage "Executing command"
    logInfoMessage "trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} --exit-code 1 --format ${FORMAT_ARG} ${WORKSPACE}/${CODEBASE_DIR}"
    trivy repo -q --severity "${SCAN_SEVERITY}" --scanners "${SCAN_TYPE}" --exit-code 1 --format "${FORMAT_ARG}" "${WORKSPACE}"/"${CODEBASE_DIR}"

    logInfoMessage "trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} --exit-code 1 ${FORMAT_ARG} -o reports/${OUTPUT_ARG} ${WORKSPACE}/${CODEBASE_DIR}"
    trivy repo -q --severity "${SCAN_SEVERITY}" --scanners "${SCAN_TYPE}" --exit-code 1 --format json -o reports/"${OUTPUT_ARG}" "${WORKSPACE}"/"${CODEBASE_DIR}"
STATUS=$(echo $?)
if [ -s "reports/${OUTPUT_ARG}" ]; then
   cat reports/"${OUTPUT_ARG}"
else
    echo "NO ${SCAN_TYPE} FOUND IN SOURCE CODE "
fi


if [ "$STATUS" -eq 0 ]
then
  logInfoMessage "Congratulations trivy scan succeeded!!!"
  generateOutput "${ACTIVITY_SUB_TASK_CODE}" true "Congratulations trivy scan succeeded!!!"
elif [ "$VALIDATION_FAILURE_ACTION" == "FAILURE" ]
  then
    logErrorMessage "Please check triyv scan failed!!!"
    generateOutput "${ACTIVITY_SUB_TASK_CODE}" false "Please check triyv scan failed!!!"
    exit 1
   else
    logWarningMessage "Please check triyv scan failed!!!"
    generateOutput "${ACTIVITY_SUB_TASK_CODE}" true "Please check triyv scan failed!!!"
    exit 1
fi
