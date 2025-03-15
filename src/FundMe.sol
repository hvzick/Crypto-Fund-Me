// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7; // this is the solidity version

import {PriceConverter} from "./PriceConverter.sol";

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

error FundMe_notOwner();

contract FundMe{
    using PriceConverter for uint256; 
    // we are attaching the library to all uint256's, so all uint256's have access to the PriceConverter library

    uint256 public constant minUsd = 5 * 1e18;
    address[] private s_funders;
    mapping (address funder => uint256 amountFunded) private s_addressToAmount;
    AggregatorV3Interface private s_priceFeed;

    // in order for a function to recieve native blockchain token you need to mark that payable

    address public immutable owner;

    constructor (address priceFeed) payable {
        owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund () public payable  {
        // we want to allow users to send money 
        // have a minimum $ amount 
        // 1e18 = 1 ETH
        // require(getConversionRate(msg.value) >= minUsd, "cant send less than 1 $");
        require(msg.value.getConversionRate(s_priceFeed) >= minUsd, "cant send less than 5 $"); // since msg.value is also uint256, so it can call .getConversionRate and pass itself ans the first input parameter to the function
        // if there are 2 parammeters to the function .getConversionRate() first one would be msg.value and the second would be passed normally like .getConversionRate(uint256 123)
        // revert undoes any actions that have been done, and sends the remaining gas back
        s_funders.push(msg.sender);
        s_addressToAmount[msg.sender] = s_addressToAmount[msg.sender] + msg.value;
    }
    function cheaperWithdraw () public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for(uint256 s_fundersIndex = 0; s_fundersIndex < fundersLength; s_fundersIndex++) {
            address funder = s_funders[s_fundersIndex];
            s_addressToAmount[funder] = 0;
        }
            s_funders = new address[] (0);
        (bool callSuccess, /*bytes memory datareturned*/) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
        
    }

    function withdraw () public onlyOwner { // onlyOwner executes whats in the modifier first
        for(uint256 s_fundersIndex = 0; s_fundersIndex < s_funders.length; s_fundersIndex++) {
            address funder = s_funders[s_fundersIndex];
            s_addressToAmount[funder] = 0;
        }
            s_funders = new address[] (0);

            // transfer: capped at 2300 gas, above that is throws error
            // msg.sender = address
            // payable(msg.sender) = payable address
            // address(this) =  address of this contract
            // address(this).balance = balance of this contract
            //payable(msg.sender).transfer(address(this).balance); // automatically reverts if it fails

            // send: capped at 2300 gas, return boolean if it fails

            // payable(msg.sender).transfer(address(this).balance);
            // if this fails the contract would not revert the transaction
            // bool sendSuccess = payable(msg.sender).send(address(this).balance);
            // require(sendSuccess, "Send Failed");

            // call: no gas cap, returns boolean when fails
            (bool callSuccess, /*bytes memory datareturned*/) = payable(msg.sender).call{value: address(this).balance}("");
            require(callSuccess, "Call Failed");
        
    } 
    modifier onlyOwner() {
        // require(msg.sender == owner, "Must be Owner");
        if(msg.sender != owner) {
            revert FundMe_notOwner();
        }
        _; // mean execute above line first then whats in the function execute that
    }
    

    receive() external payable {
        fund();
    }
    fallback() external payable {
        fund();
    }
    
    function getVersion() public view returns (uint256) {
    // Replace with AggregatorInterface if version is required.
    return s_priceFeed.version(); //
    } 
    function getAddressToAmoutFunded (address fundingAddress) external view returns (uint256) {
        return s_addressToAmount[fundingAddress];
    }
    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }
    function getOwner () external view returns (address) {
        return owner;
    }
}
