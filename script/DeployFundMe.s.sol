// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/FundMe.sol";

import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run () external returns (FundMe){
        // doesnt send as a real tx
        HelperConfig hc = new HelperConfig();
        address ethUsdPriceFeed = hc.activeNetworkConfig();
        // sends a real transaction / tx
        vm.startBroadcast();
        FundMe fundme = new FundMe(ethUsdPriceFeed); 
        vm.stopBroadcast();
        return fundme;
    }

}
