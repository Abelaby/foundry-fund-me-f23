// SPDX-License-Identifier: MIT

// 1.Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chains
// Sepolia ETH/USD
//Mainnet ETH/USD


pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggregator.sol";

contract HelperConfig is Script{
    //If we are on a local anvil chain, we are gonna deploy a mock
    //otherwise, grab the existing address fdrom the live network

    NetworkConfig public activenetWorkConfig;
    
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_VALUE = 2000e8;

    struct NetworkConfig {
        address priceFeed;  // ETH/USD price feed address
    }
constructor(){
    if(block.chainid == 11155111){
        activenetWorkConfig = getSepoliaEthConfig();
    }else if(block.chainid == 1){
        activenetWorkConfig = getEthConfig();
    }
    else{
        activenetWorkConfig = getOrCreateAnvilEthConfig();
    }

}

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        //price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed:
        0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return sepoliaConfig;
        }

    function getEthConfig() public pure returns(NetworkConfig memory){
        //price feed address
        NetworkConfig memory ethConfig = NetworkConfig({priceFeed:
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return ethConfig;
        }    

    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){
        //price feed address
        if(activenetWorkConfig.priceFeed != address(0)){
            return activenetWorkConfig;
        }

        // 1.Deploy mocks
        //2. Return the mock contracts

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_VALUE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return anvilConfig;
    }
}