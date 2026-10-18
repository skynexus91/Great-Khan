// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

contract KhanTokenTest {
    KhanToken internal token;
    address internal constant ALICE = address(0xA11CE);
    address internal constant BOB = address(0xB0B);
    uint256 internal constant SUPPLY = 1_000_000_000 ether;

    function setUp() public { token = new KhanToken(address(this), address(this), address(this), address(0xCA57)); }

    function testMetadataAndExactSupply() public {
        require(keccak256(bytes(token.name())) == keccak256(bytes("The Great Khan")));
        require(keccak256(bytes(token.symbol())) == keccak256(bytes("KHAN")));
        require(token.decimals() == 18);
        require(token.totalSupply() == SUPPLY);
        require(token.balanceOf(address(this)) == SUPPLY);
    }
    function testTransferConservesSupply() public {
        require(token.transfer(ALICE, 100 ether));
        require(token.balanceOf(ALICE) == 100 ether);
        require(token.balanceOf(address(this)) == SUPPLY - 100 ether);
        require(token.totalSupply() == SUPPLY);
    }
    function testAllowanceAndTransferFrom() public {
        require(token.approve(address(this), 40 ether));
        require(token.transferFrom(address(this), BOB, 30 ether));
        require(token.allowance(address(this), address(this)) == 10 ether);
        require(token.balanceOf(BOB) == 30 ether);
    }
    function testZeroValueTransfer() public {
        require(token.transfer(ALICE, 0));
        require(token.balanceOf(ALICE) == 0);
    }
    function testInfiniteApproval() public {
        require(token.approve(address(this), type(uint256).max));
        require(token.transferFrom(address(this), ALICE, 1 ether));
        require(token.allowance(address(this), address(this)) == type(uint256).max);
    }
    function testApproveResetToZero() public {
        require(token.approve(BOB, 10));
        require(token.approve(BOB, 0));
        require(token.approve(BOB, 20));
        require(token.allowance(address(this), BOB) == 20);
    }
    function _selector(bytes memory reason) internal pure returns (bytes4 result) {
        require(reason.length >= 4, "short revert");
        assembly { result := mload(add(reason, 32)) }
    }
    function testRejectZeroHolder() public {
        bool reverted;
        try new KhanToken(address(0), address(this), address(this), address(0xCA57)) returns (KhanToken) {} catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.ZeroAddress.selector); reverted = true;
        }
        require(reverted, "unexpected success");
    }
    function testRejectZeroRecipient() public {
        bool reverted;
        try token.transfer(address(0), 1) {} catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.ZeroAddress.selector); reverted = true;
        }
        require(reverted, "unexpected success");
    }
    function testRejectInsufficientBalance() public {
        bool reverted;
        try token.transfer(ALICE, SUPPLY + 1) {} catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.InsufficientBalance.selector); reverted = true;
        }
        require(reverted, "unexpected success");
    }
    function testRejectInsufficientAllowance() public {
        bool reverted;
        try token.transferFrom(ALICE, BOB, 1) {} catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.InsufficientAllowance.selector); reverted = true;
        }
        require(reverted, "unexpected success");
    }
    function testRejectNonzeroAllowanceChange() public {
        require(token.approve(BOB, 10));
        bool reverted;
        try token.approve(BOB, 20) {} catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.AllowanceMustBeZeroFirst.selector); reverted = true;
        }
        require(reverted, "unexpected success");
    }
}
