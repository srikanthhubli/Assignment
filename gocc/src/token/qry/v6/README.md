================================================
Chaincode Setup in Dev mode BROKEN on Fabric 2.0
================================================

=======================================
Environment Setup & Data Initialization
=======================================
# 1. Setup the vendor dependencies
cd $GOPATH/src/token/qry/v6
./govendor.sh

# 2. Launch the environment with CouchDB enabled
dev-init.sh  -s

# 3. Deploy the chaincode
. set-env.sh  priceauthority

reset-chain-env.sh

set-chain-env.sh -n PriceTxn -v 1.0 -p token/qry/v6 -c '{"Args":[]}' -C farmersorguchannel
set-chain-env.sh -I false  <<Init not needed>>

chain.sh install -p
chain.sh instantiate

# 4. Upload the data (It may take 15+ minutes)

cd $GOPATH/src/token/qry/v6/data

<<Terminal #1>> Optional 
cd $GOPATH/src/token/qry/v6/data
. set-env.sh  priuceauthority
cc-logs.sh -f

<<Termonal #2>>
cd $GOPATH/src/token/qry/v6/data
. set-env.sh  priceauthority

./setup-data.sh



===================
GetByProductIdNumber
===================
- Get the records of 1740103
set-chain-env.sh -q '{"Args":["GetByProductIdNumber","xyz123"]}'
chain.sh query


#3 Converted the data from csv to json format
http://www.convertcsv.com/csv-to-json.htm



CouchDB Indexes
===============
http://docs.couchdb.org/en/stable/api/database/find.html#db-index
http://localhost:5984/_utils/