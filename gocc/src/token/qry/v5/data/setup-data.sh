#!/bin/bash

. set-env.sh srienterprices



# jq -n --slurpfile arr ./convertcsv.json '$arr' 
# length=$( cat convertcsv.json | jq length)
# arr=$( cat convertcsv.json | jq '.[0]')

# Read the elements in an array
arr=$(cat records.json | jq -c '.[]')

# Document type for the data
docType="\"SrienterpricesData\""

# echo $arr
COUNTER=1
for item in $arr;
do
  echo $item

  echo "********************************************************************************************************************************************"

  BatchId=$(echo $item | jq .BatchId)
  echo $BatchId

  LogisticsId=$(echo $item | jq .LogisticsId)
  temp="${LogisticsId%\"}"
  temp="${temp#\"}"
  LogisticsId=$temp

  FarmersId=$(echo $item | jq .FarmersId)
  temp="${BatchId%\"}"
  temp="${temp#\"}"
  FarmersId=$temp

  ProductId=$(echo $item | jq .ProductId)
  temp="${ProductId%\"}"
  temp="${temp#\"}"
  ProductId=$temp

  ProductName=$(echo $item | jq .ProductName)
  temp="${ProductName%\"}"
  temp="${temp#\"}"
  ProductName=$temp

  Quantity=$(echo $item | jq .Quantity)

  DateOfArrival=$(echo $item | jq .DateOfArrival)
  temp="${DateOfArrival%\"}"
  temp="${temp#\"}"
  DateOfArrival=$temp

  PlaceOfArrival=$(echo $item | jq .PlaceOfArrival)
  temp="${PlaceOfArrival%\"}"
  temp="${temp#\"}"
  PlaceOfArrival=$temp

  

  echo "$COUNTER  $BatchID"
  COUNTER=$((COUNTER+1))

  args="{\"Args\":[\"AddData\",$docType,$BatchId,\"$LogisticsId\", \"$FarmersId\",\"$ProductId\",\"$ProductName\",\"$Quantity\",\"$DateOfArrival\",\"$PlaceOfArrival\"]}"
  set-chain-env.sh -i  "$args"
  #show-chain-env.sh
  chain.sh invoke

  echo $args

done

    