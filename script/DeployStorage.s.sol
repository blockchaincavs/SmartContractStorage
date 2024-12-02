// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import { Script, console } from "forge-std/Script.sol";
import { Storage } from "../src/Storage.sol";

contract DeployStorage is Script {

    function run() external {

        // anything between startBroadcast and stopBroadcast sends to the rpc
        vm.startBroadcast();
        Storage storageContract = new Storage();
        vm.stopBroadcast();
        console.log("Contract deployed! Address:", address(storageContract));
    }
}
