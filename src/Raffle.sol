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

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";


/**
 * @title A sample Raffle contract
 * @author Pranav Vinodan
 * @notice Implements Chainlink VRFv2
 */
contract Raffle {
    error Raffle_NotEnoughEthSent(); 

    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee; // I means immutable
    address payable[] private s_players; // S means state variable
    // @dev Duration of lottery in seconds.
    uint256 private immutable i_interval;
    uint256 private s_lastTimeStamp;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator; // Here we are using an interface to interact with the VRFCoordinatorV2 contract.
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    /** Events */
    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee, uint256 interval, address vrfCoordinator, bytes32 gasLane, uint64 subscriptionId, uint32 callbackGasLimit) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator); // Here we are typecasting the address to the VRFCoordinatorV2Interface.
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRafflr() external payable{
        if (msg.value < i_entranceFee) {
            revert Raffle_NotEnoughEthSent();
        } // Custom errors are more gas efficient as compared to require statements, so always use custom errors. 

        s_players.push(payable(msg.sender));
        // 1.Events make migration of contracts easier.
        // 2. Makes front end "indexing" easier.
        emit EnteredRaffle(msg.sender);
    }

//1. Get random number
// 2. Use the random number to pick a player.
// 3. Be automatically called.
    function pickWinner() public {
        //check to see if enough time passed.
        if (block.timestamp - s_lastTimeStamp < i_interval){
            revert();
        } // block.timestamp is the current time in seconds since the epoch.

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

    /** Getter Function */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }

    function getPlayers() external view returns (address payable[] memory) {
        return s_players;
    }

}