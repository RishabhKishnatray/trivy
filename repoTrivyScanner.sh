#!/bin/bash
source functions.sh
source log-functions.sh
cd  "${CODEBASE_LOCATION}"
#code="$WORKSPACE/$CODEBASE_DIR"
#cd $code
if [ -d "reports" ]; then
    true
else
    mkdir reports
fi

STATUS=0

    logInfoMessage "I'll scan source-code licenses ${WORKSPACE}/${CODEBASE_DIR} for only ${SCAN_SEVERITY} severities"
    sleep  $SLEEP_DURATION
    logInfoMessage "Executing command"
#    logInfoMessage "trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} ${FORMAT_ARG} ${WORKSPACE}/${CODEBASE_DIR}"
#    trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} ${FORMAT_ARG} ${WORKSPACE}/${CODEBASE_DIR}
    logInfoMessage "trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} --exit-code 1 ${FORMAT_ARG} -o reports/${OUTPUT_ARG} ${WORKSPACE}/${CODEBASE_DIR}"
    trivy repo -q --severity ${SCAN_SEVERITY} --scanners ${SCAN_TYPE} --exit-code 1 ${FORMAT_ARG} -o reports/${OUTPUT_ARG} ${WORKSPACE}/${CODEBASE_DIR}

if [ -s "reports/${OUTPUT_ARG}" ]; then
    cat reports/${OUTPUT_ARG}
else
    echo "NO ${SCAN_TYPE} FOUND"
fi

    STATUS=`echo $?`

if [ $STATUS -eq 0 ]
then
  logInfoMessage "Congratulations trivy scan succeeded!!!"
  generateOutput ${ACTIVITY_SUB_TASK_CODE} true "Congratulations trivy scan succeeded!!!"
elif [ $VALIDATION_FAILURE_ACTION == "FAILURE" ]
  then
    logErrorMessage "Please check triyv scan failed!!!"
    generateOutput ${ACTIVITY_SUB_TASK_CODE} false "Please check triyv scan failed!!!"
    exit 1
   else
    logWarningMessage "Please check triyv scan failed!!!"
    generateOutput ${ACTIVITY_SUB_TASK_CODE} true "Please check triyv scan failed!!!"
fi
