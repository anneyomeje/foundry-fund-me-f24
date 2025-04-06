// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Script, console } from "forge-std/Script.sol";
import { DevOpsTools } from "../lib/foundry-devops/src/DevOpsTools.sol";
import { FundMe } from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.1 ether;

    function fundFundMe(address mostRecentDeployedFundMe) public { 
        vm.prank(msg.sender); // Make the next call from USER || vm.prank(USER) would not work in this case it only affects the next call, and only in the current context (i.e., InteractionsTest). fundFundMe.fundFundMe(...) is a call to another contract. So inside fundFundMe, msg.sender is the FundFundMe contract, not USER.
        FundMe(payable(mostRecentDeployedFundMe)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        vm.startBroadcast();
        fundFundMe(mostRecentDeployedFundMe);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
   function withdrawFundMe(address mostRecentDeployedFundMe) public {  
        vm.startBroadcast(); 
        FundMe(payable(mostRecentDeployedFundMe)).withdraw();
        vm.stopBroadcast();
    }


    function run() external {
        address mostRecentDeployedFundMe = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployedFundMe);
        vm.stopBroadcast();
    }
}