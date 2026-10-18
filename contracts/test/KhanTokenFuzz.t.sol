// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanToken.sol";

contract KhanTokenFuzzTest {
    KhanToken internal token;
    address internal constant RECEIVER = address(0xBEEF);

    function setUp() public {
        token = new KhanToken(address(this), 1_000_000 ether);
    }

    function testFuzzTransferPreservesSupply(uint256 amount) public {
        amount = amount % (1_000_000 ether + 1);
        require(token.transfer(RECEIVER, amount));
        assert(token.balanceOf(RECEIVER) == amount);
        assert(token.balanceOf(address(this)) + token.balanceOf(RECEIVER) == token.totalSupply());
    }

    function testFuzzApproveAndSpend(uint256 amount) public {
        amount = amount % (1_000_000 ether + 1);
        require(token.approve(address(this), amount));
        require(token.transferFrom(address(this), RECEIVER, amount));
        assert(token.allowance(address(this), address(this)) == 0);
        assert(token.balanceOf(RECEIVER) == amount);
    }

    function testZeroInitialHolderReverts() public {
        bool reverted;
        try new KhanToken(address(0), 100) { }
        catch { reverted = true; }
        require(reverted, "expected zero-holder revert");
    }
}
