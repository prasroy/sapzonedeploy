#!/bin/bash

# Check that all of the directories were created

checkDirectoryExists() {
    DIRECTORY=$1
    assertTrue "[ -d "$DIRECTORY" ]"
}

checkMountPointCorrectSize() {
    DIRECTORY=$1
    EXPECTED_SIZE=$2
    ACTUAL_SIZE="$(df -h --output=size $DIRECTORY | awk 'NR==2')"
    assertEquals $EXPECTED_SIZE $ACTUAL_SIZE
}


testLogDirCreated() {
    checkDirectoryExists "/hana/log/PR1"
    checkMountPointCorrectSize "/hana/log/PR1" "512G"
}

testDataDirCreated() {
    checkDirectoryExists "/hana/data/PR1"
    checkMountPointCorrectSize "/hana/data/PR1" "512G"
}

testSharedDirCreated() {
    checkDirectoryExists "/hana/shared/PR1"
    checkMountPointCorrectSize "/hana/shared/PR1" "512G"
}

testDbSetup() {
    RESULT="$(echo -e "select 1 from dummy;" | hdbsql -x -a -i 00 -u SYSTEM -p <SYSTEM password> | awk 'END{print}')";
    assertEquals 1 $RESULT
}

. ./shunit2
