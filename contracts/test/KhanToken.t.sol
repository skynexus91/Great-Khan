// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

contract KhanTokenTest {
    KhanToken internal token;
    address internal constant ALICE = address(0xA11CE);
    address internal constant BOB = address(0xB0B);
    function setUp() public { token = new KhanToken(address(this), 1000 ether); }
    function testMetadataAndSupply() public {
        require(keccak256(bytes(token.symbol())) == keccak256(bytes("KHAN")));
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
    function _selector(bytes memory reason) internal pure returns (bytes4 result) {
        require(reason.length >= 4, "short revert");
        assembly { result := mload(add(reason, 32)) }
    }
    function testRejectZeroRecipient() public {
        try token.transfer(address(0), 1) { revert("unexpected success"); }
        catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.ZeroAddress.selector, "wrong revert");
        }
    }
    function testRejectInsufficientBalance() public {
        try token.transfer(ALICE, 1001 ether) { revert("unexpected success"); }
        catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.InsufficientBalance.selector, "wrong revert");
        }
    }
    function testRejectInsufficientAllowance() public {
        try token.transferFrom(ALICE, BOB, 1) { revert("unexpected success"); }
        catch (bytes memory reason) {
            require(_selector(reason) == KhanToken.InsufficientAllowance.selector, "wrong revert");
        }
    }
}
