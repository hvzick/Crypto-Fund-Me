// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/FundMe.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;
    constructor() {
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilconfig();
        }
    }

    struct NetworkConfig {
        address priceFeed;
    }

    function getSepoliaConfig () public pure returns (NetworkConfig memory) {
            // price feed address
            NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306});
            return sepoliaConfig;
    }
    function getETHMainnetConfig  () public pure returns (NetworkConfig memory) {
            // create dummy contract and return a mock address
    }
    function getOrCreateAnvilconfig () public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // for etherium mainnet 
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed : address(mockPriceFeed)});
        return anvilConfig;
    }
}