// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

/// @notice Anvil / Sepolia ONLY. Never supply a private key to a chat or repository.
interface VmDeploy {
    function envAddress(string calldata key) external returns (address);
    function startBroadcast() external;
    function stopBroadcast() external;
}
contract DeployKhan {
    VmDeploy private constant vm = VmDeploy(address(uint160(uint256(keccak256("hevm cheat code")))));
    function run() external returns (KhanToken token) {
        require(block.chainid == 31337 || block.chainid == 11155111, "only Anvil or Sepolia");
        address holder = vm.envAddress("KHAN_INITIAL_HOLDER");
        require(holder != address(0), "zero holder");
        vm.startBroadcast();
        token = new KhanToken(holder);
        vm.stopBroadcast();
    }
}
