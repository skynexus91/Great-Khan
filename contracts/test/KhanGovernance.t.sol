// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

interface VmTime { function warp(uint256) external; function prank(address) external; }

contract KhanGovernanceTest {
    VmTime private constant vm = VmTime(address(uint160(uint256(keccak256("hevm cheat code")))));
    KhanToken token;
    address constant ALICE = address(0xA11CE);
    address constant GUARDIAN = address(0x600D);
    address constant CUSTODY = address(0xCA57);
    bytes32 constant MINT_ID = keccak256("mint-case-1");
    bytes32 constant SEIZE_ID = keccak256("seize-case-1");

    function setUp() public {
        token = new KhanToken(address(this), address(this), GUARDIAN, CUSTODY);
    }
    function testInitialAndCap() public {
        require(token.totalSupply() == 1_000_000_000 ether);
        require(token.CAP() == 5_000_000_000 ether);
    }
    function testMintRequiresDelayAndEnforcesCap() public {
        token.queueMint(MINT_ID, ALICE, 4_000_000_000 ether);
        bool reverted;
        try token.executeMint(MINT_ID, ALICE, 4_000_000_000 ether) {} catch { reverted = true; }
        require(reverted, "mint before delay");
        vm.warp(block.timestamp + 2 days);
        token.executeMint(MINT_ID, ALICE, 4_000_000_000 ether);
        require(token.totalSupply() == token.CAP());
        require(token.balanceOf(ALICE) == 4_000_000_000 ether);
        reverted = false;
        try token.queueMint(keccak256("mint-case-2"), ALICE, 1) {} catch { reverted = true; }
        require(reverted, "cap bypass");
    }
    function testMintCannotReplay() public {
        token.queueMint(MINT_ID, ALICE, 1 ether);
        vm.warp(block.timestamp + 2 days);
        token.executeMint(MINT_ID, ALICE, 1 ether);
        bool reverted;
        try token.executeMint(MINT_ID, ALICE, 1 ether) {} catch { reverted = true; }
        require(reverted, "mint replay");
    }
    function testGuardianFreezeBlocksTransfersAndApprovals() public {
        token.transfer(ALICE, 10 ether);
        vm.prank(GUARDIAN);
        token.freeze(ALICE, keccak256("freeze-1"));
        require(token.frozen(ALICE));
        bool reverted;
        try token.transfer(ALICE, 1) {} catch { reverted = true; }
        require(reverted, "frozen inbound");
        vm.prank(ALICE);
        try token.transfer(address(this), 1) {} catch { reverted = true; }
        require(reverted, "frozen outbound");
        token.unfreeze(ALICE, keccak256("review-1"));
        require(!token.frozen(ALICE));
    }
    function testSeizureToCustodyOnlyAfterDelay() public {
        token.transfer(ALICE, 100 ether);
        vm.prank(GUARDIAN);
        token.freeze(ALICE, keccak256("freeze-2"));
        token.queueSeizure(SEIZE_ID, ALICE, 40 ether);
        bool reverted;
        try token.executeSeizure(SEIZE_ID, ALICE, 40 ether) {} catch { reverted = true; }
        require(reverted, "seizure before delay");
        vm.warp(block.timestamp + 2 days);
        token.executeSeizure(SEIZE_ID, ALICE, 40 ether);
        require(token.balanceOf(ALICE) == 60 ether);
        require(token.balanceOf(CUSTODY) == 40 ether);
        require(token.totalSupply() == 1_000_000_000 ether);
    }
    function testPauseAndUnpause() public {
        vm.prank(GUARDIAN);
        token.pause();
        bool reverted;
        try token.transfer(ALICE, 1) {} catch { reverted = true; }
        require(reverted, "pause bypass");
        token.unpause();
        require(token.transfer(ALICE, 1));
    }
    function testUnauthorizedCannotQueueOrFreeze() public {
        vm.prank(ALICE);
        bool reverted;
        try token.queueMint(MINT_ID, ALICE, 1 ether) {} catch { reverted = true; }
        require(reverted, "unauthorized mint");
        vm.prank(ALICE);
        reverted = false;
        try token.freeze(ALICE, keccak256("x")) {} catch { reverted = true; }
        require(reverted, "unauthorized freeze");
    }
}
