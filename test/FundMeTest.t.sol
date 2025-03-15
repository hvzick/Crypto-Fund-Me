// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import {Test, console} from "forge-std/Test.sol";

import {FundMe} from "../src/FundMe.sol";

import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundme;
    address USER = makeAddr("user");
    uint256 constant GAS_PRICE = 1;
    uint256 constant STARTNG_PRICE = 100 ether;
    uint256 constant SEND_VALUE = 0.1 ether;
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundme = deployFundMe.run();
        vm.deal(USER, STARTNG_PRICE);
    }

    function testMinUSD() public view {
        assertEq(fundme.minUsd(), 5e18);
    }
    function testOwnerTest() public view {
        // console.log(fundme.owner());
        // console.log(msg.sender);
        assertEq(fundme.owner(), msg.sender /*address(this)*/); // beause when we do vm,broadcast the contract is getting deployed by the funder so it makes it message sender
    }
    function testGetVersion() public view {
        uint256 version = fundme.getVersion(); 
        // console.log("Chainlink aggregator version:", version);
        assertEq(version, 4);
    }
    function test_RevertWhen_NotEnoughETH () public {
        vm.expectRevert(); // fails if next statement fails
        fundme.fund{value: 0}(); // send 0 value
    }
    function test_FunderUpdates () public {
        vm.prank(USER); //the next TX will be send by USER
        fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmoutFunded(USER);
        assertEq(amountFunded, SEND_VALUE);

    }
    function test_AddFunderToArrayOfFunders() public funded {
        // vm.prank(USER);
        // fundme.fund{value: 1e18}();
        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }
    function testOnlyOwner() public funded {
        // vm.prank(USER);
        // fundme.fund{value: 1e18}();    
        vm.expectRevert();
        vm.prank(USER);   
        fundme.withdraw();
    }
    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();    
        _;
    }
    function testWithdrawASingleFunder() public {
        // Arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;
        // Act
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        console.log(gasUsed);

        //Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }
    function testFromMultipleFunders() public funded {
        uint160 numberOfFunder = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunder; i++){
            // vm.prank = new address
            // vm.deal = send them money
            // fund the fundme
            hoax(address(i),SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;
        vm.prank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        // ASSERT 
        assert(address(fundme).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance);
    }
        
    function testFromMultipleFundersCheaper() public funded {
        uint160 numberOfFunder = 10;
        uint160 startingFunderIndex = 0;
        for (uint160 i = startingFunderIndex; i < numberOfFunder; i++){
            // vm.prank = new address
            // vm.deal = send them money
            // fund the fundme
            hoax(address(i),SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;
        vm.prank(fundme.getOwner());
        fundme.cheaperWithdraw();
        vm.stopPrank();

        // ASSERT 
        assert(address(fundme).balance == 0);
        assert(startingFundMeBalance + startingOwnerBalance == fundme.getOwner().balance);
    }
}

// us -> fundmetest -> fundme, give error if we check who is deploying the contract because its the fundmetest which deployed the contract