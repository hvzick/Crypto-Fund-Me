// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";
import {Script} from "forge-std/Script.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 public constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast(); 
FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
vm.stopBroadcast();
        console.log("funded fundme with %s", SEND_VALUE);
    }


    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment ("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        
        vm.stopBroadcast();
    }
    
}
contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
vm.startBroadcast();     FundMe(payable(mostRecentlyDeployed)).withdraw();
vm.stopBroadcast();
    }
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment ("FundMe", block.chainid);
        vm.startBroadcast(); 
        withdrawFundMe(mostRecentlyDeployed);
vm.stopBroadcast();
    }
}