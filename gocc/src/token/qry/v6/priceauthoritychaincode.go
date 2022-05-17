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
type PriceDataChaincode struct {
}

// CryptocoinData represents a standard token implementation
type FarmersData struct {
	DocType     string    `json:"docType"`
	ProductId   string    `json:"Productid"`
	ProductName string    `json:"ProductName"`
	Price       uint64    `json:"Quantity"`
	DateOfPrice time.Time `json:"DateOfDispatch"`
}

// Init Implements the Init method
func (token *PriceDataChaincode) Init(stub shim.ChaincodeStubInterface) peer.Response {

	// Simply print a message
	fmt.Println("Init executed in qry")

	// Return success
	return shim.Success(nil)
}

// Invoke method
func (token *PriceDataChaincode) Invoke(stub shim.ChaincodeStubInterface) peer.Response {

	// Get the function name and parameters
	funcName, args := stub.GetFunctionAndParameters()

	fmt.Println("Invoke executed - ", funcName)

	if funcName == "AddData" {
		return AddData(stub, args)
	} else if funcName == "GetByProductIdNumber" {
		return GetByProductIdNumber(stub, args)
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
	DateOfPrice := args[4]
	// parse the string to time type
	layout := "2006-01-02"
	DateOfPriceConverted, err := time.Parse(layout, DateOfPrice)

	if err != nil {
		fmt.Printf("Date parse error= %s", err.Error())
	} else {
		fmt.Printf("Date=%s ", DateOfPrice)
	}

	Productid := args[1]
	Productname := args[2]
	Price := ConvertToNumber(args[3])

	data := FarmersData{DocType: docType, ProductId: Productid, ProductName: Productname, Price: Price, DateOfPrice: DateOfPriceConverted}
	jsonData, _ := json.Marshal(data)
	stub.PutState(Productid, jsonData)
	return shim.Success([]byte("ok"))
}

// ConvertToNumber converts the passed string to uint64
func ConvertToNumber(num string) uint64 {
	uintNum, _ := strconv.ParseUint(num, 10, 64)
	return uintNum
}

// GetByDate returns the data for the specified registernumber
func GetByProductIdNumber(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	// Coincidentally we have used the TxnDate as the key
	// so we may use the GetState function instead of Rich Query function
	// with selector on TxnDate
	data, _ := stub.GetState(args[0])

	return shim.Success([]byte(data))
}

// Chaincode registers with the Shim on startup
func main() {
	fmt.Printf("Started RecordsDataChaincode. token/qry/v3\n")
	err := shim.Start(new(PriceDataChaincode))
	if err != nil {
		fmt.Printf("Error starting chaincode: %s", err)
	}
}
