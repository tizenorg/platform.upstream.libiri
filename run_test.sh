#!/bin/bash

PACKAGE_NAME=$1
PACKAGE_VERSION=$2

TEST_LOG="/tmp/${PACKAGE_NAME}_test"
export TEST_LOG
rm -f ${TEST_LOG}

# Color
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Cyan='\e[0;36m'         # Cyank

# Bold
BWhite='\e[1;37m'       # White

result_check() {
    result=$?
    test_case=$1
    if [ $result -eq 0 ]
    then
        echo -e "${Green}PASS${Color_Off}: $test_case"
        echo "TEST: PASS: $test_case" >> ${TEST_LOG}
    else
        echo -e "${Red}FAIL${Color_Off}: $test_case"
        echo -e "TEST: FAIL: $test_case" >> ${TEST_LOG}
    fi
}

skip_test() {
    test_case=$1
    echo -e "${Cyan}SKIP${Color_Off}: $test_case"
    echo "TEST: SKIP: $test_case" >> ${TEST_LOG}
}

run_test() {
    test_case=$1
    test_arg=$2
    pushd tests
    ./${test_case} ${test_arg} > ${test_case}.ref 2>&1
    diff ${test_case}.ans ${test_case}.ref
    result_check "diff ${test_case}.ans ${test_case}.ref"
    popd

}

run_test_sort() {
    test_case=$1
    test_arg=$2
    pushd tests
    ./${test_case} ${test_arg} 2>&1 | sort > ${test_case}.ref
    diff ${test_case}.ans ${test_case}.ref
    result_check "diff ${test_case}.ans ${test_case}.ref"
    popd

}

    run_test iridump "abc://username:password@example.com:123/path/data?key=value#fragid1"

TOTAL_CNT=`grep "TEST:" ${TEST_LOG} | wc -l`
PASS_CNT=`grep "PASS:" ${TEST_LOG} | wc -l`
FAIL_CNT=`grep "FAIL:" ${TEST_LOG} | wc -l`
SKIP_CNT=`grep "SKIP:" ${TEST_LOG} | wc -l`


br='==================='; br=$br$br$br$br;

echo -e "${Green}$br ${Color_Off}"
echo -e "${Green}Testsuite summary for ${PACKAGE_NAME} ${PACKAGE_VERSION}${Color_Off}"
echo -e "${Green}$br ${Color_Off}"
echo -e "#${BWhite} TOTAL: $TOTAL_CNT ${Color_Off}"
echo -e "#${Green} PASS${Color_Off} : $PASS_CNT"
echo -e "#${Red} FAIL${Color_Off} : $FAIL_CNT"
echo -e "#${Cyan} SKIP${Color_Off} : $SKIP_CNT"
echo -e "${Green}$br ${Color_Off}"

rm -f ${TEST_LOG}
exit 0

