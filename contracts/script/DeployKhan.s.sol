// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/KhanToken.sol";

/// @notice TESTNET ONLY. No real funds or production deployment.
contract DeployKhan is Script {
    function run() external returns (KhanToken token) {
        address holder = vm.envAddress("KHAN_INITIAL_HOLDER");
        uint256 supply = vm.envUint("KHAN_INITIAL_SUPPLY_WEI");
        require(holder != address(0), "zero holder");
        require(supply > 0, "zero supply");
        vm.startBroadcast();
        token = new KhanToken(holder, supply);
        vm.stopBroadcast();
    }
}
