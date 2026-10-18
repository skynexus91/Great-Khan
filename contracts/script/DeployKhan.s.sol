// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../src/KhanToken.sol";

/// @notice Foundry deployment script without external forge-std dependency.
/// @dev TESTNET ONLY. Not a production launch or authorization.
interface VmDeploy {
    function envAddress(string calldata key) external returns (address);
    function envUint(string calldata key) external returns (uint256);
    function startBroadcast() external;
    function stopBroadcast() external;
}

contract DeployKhan {
    VmDeploy private constant vm = VmDeploy(address(uint160(uint256(keccak256("hevm cheat code")))));

    function run() external returns (KhanToken token) {
        require(block.chainid == 31337 || block.chainid == 11155111, "only Anvil or Sepolia");
        address holder = vm.envAddress("KHAN_INITIAL_HOLDER");
        uint256 supply = vm.envUint("KHAN_INITIAL_SUPPLY_WEI");
        require(holder != address(0), "zero holder");
        require(supply > 0, "zero supply");
        vm.startBroadcast();
        token = new KhanToken(holder, supply);
        vm.stopBroadcast();
    }
}
