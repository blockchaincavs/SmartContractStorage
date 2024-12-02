// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {Storage} from "../src/Storage.sol";

contract StorageTest is Test {

    Storage public storageContract;
    uint256 constant STARTING_BALANCE = 0.1 ether;

    /**
     * @notice An optional function invoked before each test case is run.
     */
    function setUp() public {
        storageContract = new Storage();

        // Set balance of this contract using deal cheatcode
        deal(address(this), STARTING_BALANCE);
    }



}
