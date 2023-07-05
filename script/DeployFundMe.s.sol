// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    

    function run() external returns (FundMe){
        //before startBroadCast -> not a real "tx"
        HelperConfig helperConfig = new HelperConfig();
        (address ethUsdPriceFeed) = helperConfig.activenetWorkConfig();
       
        //after startBroadcast -> real tx!
        vm.startBroadcast();
        //Mock
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}