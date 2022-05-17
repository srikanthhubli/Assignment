#!/bin/bash

. set-env.sh farmersorg



# jq -n --slurpfile arr ./convertcsv.json '$arr' 
# length=$( cat convertcsv.json | jq length)
# arr=$( cat convertcsv.json | jq '.[0]')

# Read the elements in an array
arr=$(cat records.json | jq -c '.[]')

# Document type for the data
docType="\"FarmersData\""

# echo $arr
COUNTER=1
for item in $arr;
do
  echo $item

  echo "********************************************************************************************************************************************"

  BatchId=$(echo $item | jq .BatchId)
  echo $BatchId

  FarmersId=$(echo $item | jq .FarmersId)
  temp="${BatchId%\"}"
  temp="${temp#\"}"
  FarmersId=$temp

  FarmersName=$(echo $item | jq .FarmersName )
  temp="${FarmersName%\"}"
  temp="${temp#\"}"
  FarmersName=$temp



  ProductId=$(echo $item | jq .ProductId)
  temp="${ProductId%\"}"
  temp="${temp#\"}"
  ProductId=$temp

  ProductName=$(echo $item | jq .ProductName)
  temp="${ProductName%\"}"
  temp="${temp#\"}"
  ProductName=$temp

  Quantity=$(echo $item | jq .Quantity)

  DateOfDispatch=$(echo $item | jq .DateOfDispatch)
  temp="${DateOfDispatch%\"}"
  temp="${temp#\"}"
  DateOfDispatch=$temp

  PlaceOfDispatch=$(echo $item | jq .PlaceOfDispatch)
  temp="${PlaceOfDispatch%\"}"
  temp="${temp#\"}"
  PlaceOfDispatch=$temp

  

  echo "$COUNTER  $BatchID"
  COUNTER=$((COUNTER+1))

  args="{\"Args\":[\"AddData\",$docType,$BatchId, \"$FarmersId\",\"$FarmersName\",\"$ProductId\",\"$ProductName\",\"$Quantity\",\"$DateOfDispatch\",\"$PlaceOfDispatch\"]}"
  set-chain-env.sh -i  "$args"
  #show-chain-env.sh
  chain.sh invoke

  echo $args

done

    