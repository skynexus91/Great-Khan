// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";
import "../src/KhanSeizureEscrow.sol";

interface VmEscrow { function warp(uint256) external; function prank(address) external; }

contract KhanEmergencyEscrowTest {
    VmEscrow private constant vm = VmEscrow(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant USER = address(0xA11CE);
    address constant GUARDIAN = address(0x600D);
    KhanToken token;
    KhanSeizureEscrow escrow;

    function setUp() public {
        escrow = new KhanSeizureEscrow(address(this));
        token = new KhanToken(address(this), address(this), GUARDIAN, address(escrow));
        escrow.bindToken(address(token));
    }

    function testGuardianFreezeExpiresAfterOneDay() public {
        token.transfer(USER, 10 ether);
        vm.prank(GUARDIAN);
        token.freeze(USER, keccak256("emergency"));
        require(token.frozen(USER));
        vm.warp(block.timestamp + 1 days + 1);
        require(!token.frozen(USER));
        require(token.transfer(USER, 1 ether));
    }

    function testGuardianPauseExpiresAfterOneDay() public {
        vm.prank(GUARDIAN);
        token.pause();
        require(token.paused());
        vm.warp(block.timestamp + 1 days + 1);
        require(!token.paused());
        require(token.transfer(USER, 1 ether));
    }

    function testEscrowRecordsSeizureAndReturnsAfterReview() public {
        bytes32 id = keccak256("case-123");
        token.transfer(USER, 100 ether);
        token.queueSeizure(id, USER, 40 ether);
        vm.warp(block.timestamp + 2 days);
        token.executeSeizure(id, USER, 40 ether);
        (address source, uint256 deposited, uint256 released,, , bool disputed) = escrow.cases(id);
        require(source == USER && deposited == 40 ether && released == 0 && !disputed);
        require(token.balanceOf(address(escrow)) == 40 ether);
        escrow.queueRelease(id, USER);
        vm.warp(block.timestamp + 7 days);
        escrow.executeRelease(id);
        require(token.balanceOf(USER) == 100 ether);
        require(token.balanceOf(address(escrow)) == 0);
    }

    function testDisputeCancelsQueuedRelease() public {
        bytes32 id = keccak256("case-dispute");
        token.transfer(USER, 30 ether);
        token.queueSeizure(id, USER, 10 ether);
        vm.warp(block.timestamp + 2 days);
        token.executeSeizure(id, USER, 10 ether);
        escrow.queueRelease(id, USER);
        vm.prank(USER);
        escrow.dispute(id);
        vm.warp(block.timestamp + 8 days);
        bool reverted;
        try escrow.executeRelease(id) {} catch { reverted = true; }
        require(reverted, "dispute did not block");
        escrow.resolveDispute(id);
        escrow.queueRelease(id, USER);
        vm.warp(block.timestamp + 7 days);
        escrow.executeRelease(id);
        require(token.balanceOf(USER) == 30 ether);
    }

    function testNonTokenCannotRecordSeizure() public {
        bool reverted;
        try escrow.recordSeizure(keccak256("fake"), USER, 1 ether) {} catch { reverted = true; }
        require(reverted, "spoofed seizure");
    }

    function testUnauthorizedCannotRelease() public {
        vm.prank(USER);
        bool reverted;
        try escrow.queueRelease(keccak256("fake"), USER) {} catch { reverted = true; }
        require(reverted, "unauthorized escrow release");
    }
}
