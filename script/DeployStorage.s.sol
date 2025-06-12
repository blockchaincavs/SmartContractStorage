// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Script, console } from "forge-std/Script.sol";
import { Storage } from "../src/Storage.sol";

contract DeployStorage is Script {

    address private storageContractAddress;

    function run() external {

        // anything between startBroadcast and stopBroadcast sends to the rpc
        vm.startBroadcast();
        Storage storageContract = new Storage();
        vm.stopBroadcast();
        
        storageContractAddress = address(storageContract);
        createAddressConfigFile();
    }

    /**
    * @notice Create address config file to be used on UI and backend.
    */
    function createAddressConfigFile() private {
        
        string memory configFilePath = vm.envString("CONFIG_PATH");
        
        // random key to allow mulitple objects to be serialized
        string memory obj1 = "some key";

        // random key to allow multiple objects to be serialized
        string memory json = vm.serializeAddress(obj1, "STORAGE_CONTRACT_ADDRESS", storageContractAddress);
        vm.writeJson(json, configFilePath);
    }
}
