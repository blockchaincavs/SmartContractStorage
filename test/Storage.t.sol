// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "forge-std/Test.sol";
import {Storage} from "../src/Storage.sol";

contract StorageTest is Test {

    /**
     * Events
     */
    event NewEntry(address indexed addr, uint256 favNumber);
    event DonationReceived(address indexed addr, uint256 amount);
    event BalanceWithdrawn(uint256 amount);

    Storage public storageContract;
    uint256 private constant STARTING_BALANCE = 0.1 ether;
    uint256 private constant MY_FAVORITE_NUMBER = 7;
    uint256 private constant DONATION_AMMOUNT = 0.002 ether;

    /**
     * @notice An optional function invoked before each test case is run.
     * @dev uses deal cheat to give contract a starting balance
     */
    function setUp() public {
        storageContract = new Storage();

        // Set balance of this contract using deal cheatcode
        deal(address(this), STARTING_BALANCE);
    }

    // Receive function ensures test contract can receive ether
    receive() external payable {}

    function testOwner() public view {
        address owner = storageContract.getOwner();
        vm.assertEq(owner, address(this));
    }

    function testAdd() public view {
        uint256 x = 200; uint256 y = 23;
        uint256 result = storageContract.add(x, y);
        vm.assertEq(result, x+y);
    }

    function testFavoriteNumberNotSet() public view {
        uint256 favoriteNumber = storageContract.addressToFavoriteNumbers(address(this));
        assertEq(favoriteNumber, 0);
    }

    function testSetFavoriteNumber() public {

        vm.expectEmit(true, false, false, false, address(storageContract));
        emit NewEntry(address(this), MY_FAVORITE_NUMBER);

        storageContract.setFavoriteNumber(MY_FAVORITE_NUMBER);
        uint256 favoriteNumber = storageContract.addressToFavoriteNumbers(address(this));
        assertEq(favoriteNumber, MY_FAVORITE_NUMBER);
    }

    function testBalanceNone() public view {
        uint256 balance = storageContract.getBalance();
        assertEq(balance, 0);
    }

    function testWithdrawBalanceNone() public {
        vm.expectRevert(Storage.WithdrawFailure.selector); 
        storageContract.withdrawBalance();
    }

    function testDonateEthMinimumAmountNotMet() public {
        vm.expectRevert(Storage.MinimumDonationNotMet.selector);
        storageContract.donateEth{value: 0.0009 ether}();
    }

    function testDonateEth() public {

        // Test Donation Received event
        vm.expectEmit(true, false, false, true, address(storageContract));
        emit DonationReceived(address(this), DONATION_AMMOUNT);
        storageContract.donateEth{value: DONATION_AMMOUNT}();
        
        uint256 amount = storageContract.addressToAmountDonated(address(this));
        vm.assertEq(amount, DONATION_AMMOUNT);

        amount = storageContract.getBalance();
        vm.assertEq(amount, DONATION_AMMOUNT);

    }

    function testWithdrawBalanceSome() public {
        testDonateEth();
        
        vm.expectEmit(false, false, false, true, address(storageContract));
        emit BalanceWithdrawn(DONATION_AMMOUNT);
        storageContract.withdrawBalance();

    }

}
