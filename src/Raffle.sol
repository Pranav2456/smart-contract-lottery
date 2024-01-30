// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;


/**
 * @title A sample Raffle contract
 * @author Pranav Vinodan
 * @notice Implements Chainlink VRFv2
 */
contract Raffle {
    error Raffle_NotEnoughEthSent(); 


    uint256 private immutable i_entranceFee; // I means immutable
    address payable[] private s_players; // S means state variable

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRafflr() external payable{
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughEthSent();
        } // Custom errors are more gas efficient as compared to require statements, so always use custom errors.

        s_players.push(payable(msg.sender));
        // 1.Events make migration of contracts easier.
        // 2. Makes front end "indexing" easier.
    }

    function pickWinner() public {}

    /** Getter Function */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}