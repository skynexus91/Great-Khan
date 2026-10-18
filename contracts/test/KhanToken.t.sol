// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

contract KhanTokenTest {
    KhanToken internal token;
    address internal constant ALICE = address(0xA11CE);
    address internal constant BOB = address(0xB0B);
    function setUp() public { token = new KhanToken(address(this), 1000 ether); }
    function testMetadataAndSupply() public {
        require(keccak256(bytes(token.symbol())) == keccak256("KHAN"));
        require(token.totalSupply() == 1000 ether);
        require(token.balanceOf(address(this)) == 1000 ether);
    }
    function testTransferConservesSupply() public {
        require(token.transfer(ALICE, 100 ether));
        require(token.balanceOf(ALICE) == 100 ether);
        require(token.balanceOf(address(this)) == 900 ether);
        require(token.totalSupply() == 1000 ether);
    }
    function testAllowanceAndTransferFrom() public {
        require(token.approve(address(this), 40 ether));
        require(token.transferFrom(address(this), BOB, 30 ether));
        require(token.allowance(address(this), address(this)) == 10 ether);
        require(token.balanceOf(BOB) == 30 ether);
    }
    function testRejectZeroRecipient() public {
        try token.transfer(address(0), 1) { revert("expected revert"); } catch {}
    }
    function testRejectInsufficientBalance() public {
        try token.transfer(ALICE, 1001 ether) { revert("expected revert"); } catch {}
    }
}
