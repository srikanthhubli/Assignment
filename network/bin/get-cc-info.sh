#!/bin/bash

if [ "$FABRIC_CFG_PATH" == "" ]; then 
   echo "This script requires the Environment to be setup!!! Use one of the following:"
   echo "> source  set-env.sh  christ"
   echo "> source  set-env.sh  pn"
   echo "> source  set-env.sh  prime"
   echo "> source  set-env.sh  simplex"
   exit
fi

# Gets the informaton on the commited chaincode on the channel
function usage {
    echo   "Usage:  get-cc-info  -C [channel_id Default=$CC_CHANNEL_ID]  -n [chaincode_name Default=$CC_NAME] -e [Echo]"
    echo   "Gets the information on committed chaincode and writes out to the environment variables"
    echo   "Environment variables set by this script:"
    echo   "COMMITED_CC_NAME   COMMITTED_CC_VERSION  COMMITTED_CC_SEQUENCE  COMMITTED_INIT_REQUIRED "
}

# Write to the environment file
function write_out {
    echo "# Generated: $(date)"   > $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_CC_NAME=$COMMITTED_CC_NAME"             >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_CC_VERSION=$COMMITTED_CC_VERSION"       >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_CC_SEQUENCE=$COMMITTED_CC_SEQUENCE"     >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_INIT_REQUIRED=$COMMITTED_INIT_REQUIRED" >> $CC2_ENV_FOLDER/get-cc-info
    # echo "COMMITED_COLLECTIONS=$COMMITED_COLLECTIONS"       >> $CC2_ENV_FOLDER/get-cc-info
    # echo "CC2_PACKAGE_ID=$CC2_PACKAGE_ID"                   >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_APPROVAL_CHRIST=$COMMITTED_APPROVAL_CHRIST"         >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_APPROVAL_PN=$COMMITTED_APPROVAL_PN"         >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_APPROVAL_PRIME=$COMMITTED_APPROVAL_PRIME"         >> $CC2_ENV_FOLDER/get-cc-info
    echo "COMMITTED_APPROVAL_SIMPLEX=$COMMITTED_APPROVAL_SIMPLEX"         >> $CC2_ENV_FOLDER/get-cc-info
}

# Common location for the generated packages
CC2_PACKAGE_FOLDER=$HOME/packages

DIR="$( which set-chain-env.sh)"
DIR="$(dirname $DIR)"
# echo $DIR
source $DIR/to_absolute_path.sh
# Read the current setup
source   $DIR/cc.env.sh

# Local vars
COMMITED_CHANNEL=$CC_CHANNEL_ID
COMMITTED_CC_NAME=$CC_NAME

ECHO_INFO="false"
while getopts "C:n:he" OPTION; do

    case $OPTION in
    h)
        usage
        exit
        ;;
    C)
       COMMITED_CHANNEL=${OPTARG}
       ;;
    n)
        COMMITTED_CC_NAME=${OPTARG}
        ;;
    e)
      ECHO_INFO="true"
      ;;
    esac
done

# Set the default value 
COMMITTED_CC_VERSION=-1
COMMITTED_CC_SEQUENCE=-1
OUTPUT=$(peer lifecycle chaincode querycommitted -C $COMMITED_CHANNEL -n $COMMITTED_CC_NAME -O json)

# echo $OUTPUT

# check if there was NO error
if [ "$?" == "0" ]; then

    # Parse the values
    COMMITTED_CC_VERSION=$(echo $OUTPUT | jq .version) 
    # This gets rid of the quote characters
    COMMITTED_CC_VERSION=$(echo $COMMITTED_CC_VERSION | tr -d '"')

    COMMITTED_INIT_REQUIRED=$(echo $OUTPUT | jq .init_required) 
    if [ "$COMMITTED_INIT_REQUIRED" == "null" ]; then
        COMMITTED_INIT_REQUIRED=false
    fi
    # COMMITED_COLLECTIONS=$(echo $OUTPUT | jq .collections) 
    COMMITTED_CC_SEQUENCE=$(echo $OUTPUT | jq .sequence)

    COMMITTED_APPROVAL_CHRIST=$(echo $OUTPUT | jq .approvals.ChristMSP)
    COMMITTED_APPROVAL_PN=$(echo $OUTPUT | jq .approvals.PnMSP)
    COMMITTED_APPROVAL_PRIME=$(echo $OUTPUT | jq .approvals.PrimetMSP)
    COMMITTED_APPROVAL_SIMPLEX=$(echo $OUTPUT | jq .approvals.SimplexMSP)    

    # get-package-id.sh  -v "$COMMITTED_CC_VERSION" -n "$COMMITTED_CC_NAME"
    # source $CC2_ENV_FOLDER/get-package-id

    # get-cc-installed.sh
    # source $CC2_ENV_FOLDER/get-cc-installed &> /dev/null
else
    write_out
    exit 1
fi

# echo $ECHO_INFO
if [ "$ECHO_INFO" == "true" ]; then
    echo "COMMITTED_CC_NAME=$COMMITTED_CC_NAME"
    echo "COMMITTED_CC_VERSION=$COMMITTED_CC_VERSION"
    echo "COMMITTED_CC_SEQUENCE=$COMMITTED_CC_SEQUENCE"
    echo "COMMITTED_INIT_REQUIRED=$COMMITTED_INIT_REQUIRED"
    # echo "COMMITED_COLLECTIONS=$COMMITED_COLLECTIONS"
    # echo "CC2_PACKAGE_ID=$CC2_PACKAGE_ID"
    # echo "CC2_PACKAGE_ID_HASH=$CC2_PACKAGE_ID_HASH"
    echo "COMMITTED_APPROVAL_CHRIST=$COMMITTED_APPROVAL_CHRIST"
    echo "COMMITTED_APPROVAL_PN=$COMMITTED_APPROVAL_PN"
    echo "COMMITTED_APPROVAL_CHRIST=$COMMITTED_APPROVAL_PRIME"
    echo "COMMITTED_APPROVAL_PN=$COMMITTED_APPROVAL_SIMPLEX"
fi

write_out