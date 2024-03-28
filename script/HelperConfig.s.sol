//SPDX-License-Identifier: MIT

// Deploy Mocks when we are on anvil -> Similar to hardhat
// Keep Tract of contract address accross difft chainas

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // Price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });

        return sepoliaConfig;
    }

    // Much faster to test as there is no API calls
    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        // Check if we already deployed mocks
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        // Deploy Mocks
        // Return mock addresses

        vm.startBroadcast();
        // Take MockV3Aggreagator contract from github
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMALS, // Dont use magic numbers 😂
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConig = NetworkConfig({
            priceFeed: address(mockV3Aggregator)
        });

        return anvilConig;
    }
}
