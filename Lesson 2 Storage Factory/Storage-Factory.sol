// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Importing other contract 
import "./SimpleStorage.sol"

//Inheriting all the attributes and functions of SimpleStorage
contract StorageFactory is SimpleStorage {
	
	// Creating an array of storages
	SimpleStorage[] public simpleStorageArray;
	
	function createSimpleStorageContract() public {
		// Object     Variable name new object Calling contract 
		SimpleStorage simpleStorage = new SimpleStorage();
		//Storing new object in array
		simpleStorageArray.push(simpleStorage);
		
	}
	// Function to store a number in a specific storage among storages created
	function sfStore(uint256 _simpleStorageIndex,uint256 _simpleStorageNumber) public {
	
	// You need address and ABI(Application Binary Interface) to interact with a contract.
	
	SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
	SimpleStorage.store(_simpleStorageNumber);	
	}
	
	// Function to retrieve or view the number stored in a specific storage
	function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
	SimpleStorage simpleStorage = SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]));
	return simpleStorage.retrieve();
	}	
}
