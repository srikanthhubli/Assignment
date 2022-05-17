#!/bin/bash

. set-env.sh priceauthority



# jq -n --slurpfile arr ./convertcsv.json '$arr' 
# length=$( cat convertcsv.json | jq length)
# arr=$( cat convertcsv.json | jq '.[0]')

# Read the elements in an array
arr=$(cat records.json | jq -c '.[]')

# Document type for the data
docType="\"PriceData\""

# echo $arr
COUNTER=1
for item in $arr;
do
  echo $item

  echo "********************************************************************************************************************************************"

  ProductId=$(echo $item | jq .ProductId)
  echo $ProductId

  ProductName=$(echo $item | jq .ProductName)
  temp="${ProductName%\"}"
  temp="${temp#\"}"
  ProductName=$temp

  Price=$(echo $item | jq .Price)

  DateOfPrice=$(echo $item | jq .DateOfPrice)
  temp="${DateOfPrice%\"}"
  temp="${temp#\"}"
  DateOfPrice=$temp


  echo "$COUNTER  $BatchID"
  COUNTER=$((COUNTER+1))

  args="{\"Args\":[\"AddData\",$docType,$ProductId,\"$ProductName\",\"$Price\",\"$DateOfPrice\"]}"
  # args="{\"Args\":[\"AddData\",$docType,$BatchId,\"$LogisticsId\", \"$FarmersId\",\"$ProductId\",\"$ProductName\",\"$Quantity\",\"$DateOfArrival\",\"$PlaceOfArrival\"]}"
  set-chain-env.sh -i  "$args"
  #show-chain-env.sh
  chain.sh invoke

  echo $args

done

    