// SODX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        uint256 entranceFee; 
        uint256 interval; 
        address vrfCoordinator; 
        bytes32 gasLane; 
        uint64 subscriptionId;
        uint32 callbackGasLimit;
    } // This will help us to store the configuration of the Raffle contract for different networks.

    NetworkConfig public activeNetworkConifg;
    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConifg = getSepoliaEthConfig();
        } else {
            activeNetworkConifg = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        return NetworkConfig({
            entranceFee: 0.01 ether,
            interval: 30,
            vrfCoordinator: 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625,
            gasLane: 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c,
            subscriptionId: 0, // Update this with our subId!
            callbackGasLimit: 500000 // 500,000 gas!
        });  
    } 

    function getOrCreateAnvilEthConfig() public view returns (NetworkConfig memory) {
        if(activeNetworkConifg.vrfCoordinator != address(0)) {
            return activeNetworkConifg;
        }
     }
}