// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../../src/FundMe.sol";
import { DeployFundMe } from "../../script/DeployFundMe.s.sol";
import { FundFundMe, WithdrawFundMe } from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); // Create a new address to send transactions to our contract
    uint256 constant SEND_VALUE = 0.1 ether; // 0.1 ether = 100000000000000000 wei
    uint256 constant STARTING_BALANCE = 10 ether; // 10 ether = 10000000000000000000 wei
    uint256 constant GAS_PRICE = 1;

    function setUp() external{
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 1e18); // Fund the USER account with 1 ETH
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));   //fund with our script

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));  //withdraw with our script


        assertEq(address(fundMe).balance, 0);
    }

}