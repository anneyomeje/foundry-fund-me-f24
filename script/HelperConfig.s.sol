// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { Script, console } from "forge-std/Script.sol";
import  {MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on a local chain, deploy to mock (else grab existing address from live network)
    NetworkConfig public activeNetwork;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8; // 2000.00

    constructor(){
        if(block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else if(block.chainid == 1) {
            activeNetwork = getMainnetEthConfig();
        }else {
            activeNetwork = getAnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; //Eth to Usd
        // address wEth;
        // address vrfCoordinatorV2;
        // address linkToken;
        // address keyHash;
        // uint64 subscriptionId;
        // uint32 callbackGasLimit;
        // uint16 requestConfirmations;
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });

        return mainnetConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory) {
        if(activeNetwork.priceFeed != address(0)) {      //so we don't deploy a new mock every time
            return activeNetwork;
        }
        // Deploy MockV3Aggregator
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });
        return anvilConfig;
    }
}