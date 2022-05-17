#!/bin/bash

# Change this to control the log levels
# export CORE_LOGGING_LEVEL=info  #debug  #info #warning

usage() {
    echo ". set-env.sh   ORG_NAME  "
    echo "               Sets the environment variables for the peer that need to be used"
}

# Change this to appropriate level
DIR="$( which $BASH_SOURCE)"
DIR="$(dirname $DIR)"

export BINS_FOLDER=$DIR

source $DIR/to_absolute_path.sh

to-absolute-path $DIR
DIR=$ABS_PATH

# echo "-->$DIR"
export FABRIC_CFG_PATH="$DIR/../config"
to-absolute-path $FABRIC_CFG_PATH
FABRIC_CFG_PATH=$ABS_PATH


# export ORDERER_ADDRESS=localhost:6050
export ORDERER_ADDRESS=orderer.farmersorg.com:6050

# Sets the ORG Name
ORG_NAME=$1
if [ -z $ORG_NAME ];
then
    usage                            
    echo "Please provide the ORG Name!!!"
elif [ "$ORG_NAME" = "farmersorg" ];
then
    # echo "Switching the Org = $ORG_NAME"
    # export CORE_PEER_ADDRESS=localhost:6051
    export CORE_PEER_ADDRESS=farmersorg-peer1.farmersorg.com:6051
elif [ "$ORG_NAME" = "logistics" ];
then
    # echo "Switching the Org = $ORG_NAME"
    # export CORE_PEER_ADDRESS=localhost:7051
    export CORE_PEER_ADDRESS=logistics-peer1.logistics.com:7051
elif [ "$ORG_NAME" = "srienterprices" ];
then
    # echo "Switching the Org = $ORG_NAME"
    # export CORE_PEER_ADDRESS=localhost:8051
    export CORE_PEER_ADDRESS=srienterprices-peer1.srienterprices.com:8051
elif [ "$ORG_NAME" = "priceauthority" ];
then
    # echo "Switching the Org = $ORG_NAME"
    # export CORE_PEER_ADDRESS=localhost:9051
    export CORE_PEER_ADDRESS=priceauthority-peer1.priceauthority.com:9051        
else
    usage
    echo $ORG_NAME                            
    echo "INVALID ORG Name!!!"
fi
export CORE_PEER_ID=$ORG_NAME-peer1.$ORG_NAME.com

# Create the path to the crypto config folder
CRYPTO_CONFIG_ROOT_FOLDER=$DIR/../crypto/crypto-config/peerOrganizations
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME.com/users/Admin@$ORG_NAME.com/msp
to-absolute-path $CORE_PEER_MSPCONFIGPATH
CORE_PEER_MSPCONFIGPATH=$ABS_PATH

# Capitalize the first letter of Org name e.g., christ => Christ  pn => Pn prime => Prime simplex => Simplex
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"

# Setup the default logging spec to info
if [ -z "$FABRIC_LOGGING_SPEC" ]; then
    export FABRIC_LOGGING_SPEC=info
fi

# Sets the current org
export ORGANIZATION_CONTEXT=$1

# show-env.sh


# Write the env to the file
echo "# Environment in use"   > $DIR/env.sh
echo "export CORE_PEER_LOCALMSPID=$CORE_PEER_LOCALMSPID" >> $DIR/env.sh
echo "export CORE_PEER_MSPCONFIGPATH=$CORE_PEER_MSPCONFIGPATH" >> $DIR/env.sh
echo "export CORE_PEER_ID=$CORE_PEER_ID" >> $DIR/env.sh
# echo "export CORE_LOGGING_LEVEL=$CORE_LOGGING_LEVEL" >> $DIR/env.sh
echo "export FABRIC_LOGGING_SPEC=$FABRIC_LOGGING_SPEC" >> $DIR/env.sh
echo "export CORE_PEER_ADDRESS=$CORE_PEER_ADDRESS" >> $DIR/env.sh
echo "export ORDERER_ADDRESS=$ORDERER_ADDRESS" >> $DIR/env.sh
echo "export FABRIC_CFG_PATH=$FABRIC_CFG_PATH" >> $DIR/env.sh

# Simply checks if this script was executed directly on the terminal/shell
# it has the '.'
if [[ $0 = *"set-env.sh" ]]
then
    echo "Did you use the . before ./set-env.sh? If yes then we are good :)"
fi