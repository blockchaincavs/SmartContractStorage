// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

/**
 * @title Storage
 * @author cavs
 * @notice This contract allows a user to store their favorite number and donate ether
 */
contract Storage {

    /**
     * @dev events
     */
    event NewEntry(address indexed addr, uint256 favNumber);
    event DonationReceived(address indexed addr, uint256 amount);
    event BalanceWithdrawn(uint256 amount);

    /**
     * @dev custom errors
     */
    error NotOwner();
    error WithdrawFailure();
    error MinimumDonationNotMet(); 

    /**
     * @dev State Variables
     */

    address private immutable i_owner;
    uint256 public constant MIN_DONATION_AMOUNT = 0.001 ether;
    mapping(address => uint256) public addressToFavoriteNumbers;
    mapping(address => uint256) public addressToAmountDonated;

    /**
     * @notice Consturctor sets the owner of this contract
     */
    constructor() {
        i_owner = msg.sender; 
    }

    /**
     * @notice modifier to limit function execution to the owner of the contract.
     */
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    /**
     * @notice Receive ether to contract. It is called when no calldata is received with a transaction
     */
    receive() external payable {}

    /**
     * @notice Fallback function when calldata is received that doesn't match a function signature
     */
    fallback() external payable {}
    
    /**
     * @notice Returns the address of the owner of this contract
     */
    function getOwner() external view returns(address) {
        return i_owner;
    }

    /**
     * @notice Add to numbers
     * @dev Pure function, does not read/write state
     * @param _x First addend
     * @param _y Second addend
     * @return uint256 _x + _y
     */
    function add(uint256 _x, uint256 _y) external pure returns(uint256) {
        return _x + _y;
    }
    
    /**
     * @notice Allows a user to set his or her favorite number
     * @dev emit NewEntry event when a user sets their favorite number
     * @param _favoriteNumber of the user
     */
    function setFavoriteNumber(uint256 _favoriteNumber) external {
        addressToFavoriteNumbers[msg.sender] = _favoriteNumber;
        emit NewEntry(msg.sender, _favoriteNumber);
    }

    /**
     * @notice Get the contract balance
     * @return uint256
     */
    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }

    /**
     * @notice Withdraw balance
     * @dev Only owner can withdraw the balance
     */
    function withdrawBalance() external onlyOwner {
        uint256 amount = address(this).balance;
        if (amount < 0.001 ether) revert WithdrawFailure();
        
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        if (!success) revert WithdrawFailure();

        // emit event
        emit BalanceWithdrawn(amount);
    }

    /**
     * @notice Prefered function to receive donation of MIN_DONATION_AMOUNT
     * @dev emit DonationReceived event when donation is received
     */
    function donateEth() external payable {
        require(msg.value >= MIN_DONATION_AMOUNT, MinimumDonationNotMet());
        addressToAmountDonated[msg.sender] = msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

}