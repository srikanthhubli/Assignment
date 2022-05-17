package main

/**
 * v1 shows the use of Range functions
 **/

import (
	// For printing messages on console
	"fmt"

	"time"

	// April 2020, Updated to Fabric 2.0 Shim
	"github.com/hyperledger/fabric-chaincode-go/shim"

	peer "github.com/hyperledger/fabric-protos-go/peer"

	// JSON Encoding
	"encoding/json"

	// Conversion functions
	"strconv"
)

// CryptocoinChaincode Represents our chaincode object
type FarmersDataChaincode struct {
}

// CryptocoinData represents a standard token implementation
type FarmersData struct {
	DocType         string    `json:"docType"`
	BatchId         string    `json:"Batchid"`
	FarmersId       string    `json:"Farmersid"`
	FarmersName     string    `json:"FarmersName"`
	ProductId       string    `json:"Productid"`
	ProductName     string    `json:"ProductName"`
	Quantity        uint64    `json:"Quantity"`
	DateOfDispatch  time.Time `json:"DateOfDispatch"`
	PlaceOfDispatch string    `json:"PlaceOfDispatch"`
}

// Init Implements the Init method
func (token *FarmersDataChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {

	// Simply print a message
	fmt.Println("Init executed in qry")

	// Return success
	return shim.Success(nil)
}

// Invoke method
func (token *FarmersDataChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	// Get the function name and parameters
	funcName, args := stub.GetFunctionAndParameters()

	fmt.Println("Invoke executed - ", funcName)

	if funcName == "AddData" {
		return AddData(stub, args)
	} else if funcName == "GetByBatchIdNumber" {
		return GetByBatchIdNumber(stub, args)
	} /*else if funcName == "ExecuteRichQuery" {
		return ExecuteRichQuery(stub, args)
	} else if funcName == "GetDatesByPrice"{
		return GetDatesByPrice(stub, args)
	} else if funcName == "GetAveragesBetweenDates"{
		return GetAveragesBetweenDates(stub, args)
	} else if funcName == "GenerateVolumeReport"{
		return GenerateVolumeReport(stub, args)
	}*/

	// This is not good
	return shim.Error(("Bad Function Name = !!!"))
}

// AddData adds the data to the state
func AddData(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	docType := args[0]
	DateOfDispatch := args[7]
	// parse the string to time type
	layout := "2006-01-02"
	DateOfDispatchConverted, err := time.Parse(layout, DateOfDispatch)

	if err != nil {
		fmt.Printf("Date parse error= %s", err.Error())
	} else {
		fmt.Printf("Date=%s ", DateOfDispatch)
	}

	Batchid := args[1]
	Farmersid := args[2]
	Farmersname := args[3]
	Productid := args[4]
	Productname := args[5]
	quantity := ConvertToNumber(args[6])
	PlaceOfDispatch := args[8]

	data := FarmersData{DocType: docType, BatchId: Batchid, FarmersId: Farmersid, FarmersName: Farmersname, ProductId: Productid, ProductName: Productname, Quantity: quantity, DateOfDispatch: DateOfDispatchConverted, PlaceOfDispatch: PlaceOfDispatch}
	jsonData, _ := json.Marshal(data)
	stub.PutState(Batchid, jsonData)
	return shim.Success([]byte("ok"))
}

// ConvertToNumber converts the passed string to uint64
func ConvertToNumber(num string) uint64 {
	uintNum, _ := strconv.ParseUint(num, 10, 64)
	return uintNum
}

// GetByDate returns the data for the specified registernumber
func GetByBatchIdNumber(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	// Coincidentally we have used the TxnDate as the key
	// so we may use the GetState function instead of Rich Query function
	// with selector on TxnDate
	data, _ := stub.GetState(args[0])

	return shim.Success([]byte(data))
}

// Chaincode registers with the Shim on startup
func main() {
	fmt.Printf("Started RecordsDataChaincode. token/qry/v3\n")
	err := shim.Start(new(FarmersDataChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}
