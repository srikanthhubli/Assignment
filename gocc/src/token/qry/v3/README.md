================================================
Chaincode Setup in Dev mode BROKEN on Fabric 2.0
================================================

=======================================
Environment Setup & Data Initialization
=======================================
# 1. Setup the vendor dependencies
cd $GOPATH/src/token/qry/v3
./govendor.sh

# 2. Launch the environment with CouchDB enabled
dev-init.sh  -s

# 3. Deploy the chaincode
. set-env.sh  farmersorg

reset-chain-env.sh

set-chain-env.sh -n BatchidfarmersTxn -v 1.0 -p token/qry/v3 -c '{"Args":[]}' -C farmersorguchannel
set-chain-env.sh -I false  <<Init not needed>>

chain.sh install -p
chain.sh instantiate

# 4. Upload the data (It may take 15+ minutes)

cd $GOPATH/src/token/qry/v3/data

<<Terminal #1>> Optional 
cd $GOPATH/src/token/qry/v3/data
. set-env.sh  farmersorg
cc-logs.sh -f

<<Termonal #2>>
cd $GOPATH/src/token/qry/v3/data
. set-env.sh  farmersorg

./setup-data.sh

================
ExecuteRichQuery
================
set-chain-env.sh -q '{"Args":["ExecuteRichQuery","{\"selector\":{\"txnDate\": \"2009-12-12T00:00:00Z\"}}"]}'
chain.sh query

# Utility for executing queries:
PS: Remember query attributes limit & skip are ignored by Fabric

qry/v3/samples
./run-query.sh    #NUMBER#      Executes the query against chaincode
./run-query.sh    1.1           Executes the query in file:  query-1.1.json

===================
GetByRegisterNumber
===================
- Get the records of 1740103
set-chain-env.sh -q '{"Args":["GetByRegisterNumber","1740103"]}'
chain.sh query


#3 Converted the data from csv to json format
http://www.convertcsv.com/csv-to-json.htm



CouchDB Indexes
===============
http://docs.couchdb.org/en/stable/api/database/find.html#db-index
http://localhost:5984/_utils/