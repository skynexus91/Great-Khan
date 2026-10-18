// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Experimental KHAN ERC-20, Sepolia testing only. NOT AUDITED.
/// @dev Fixed supply minted once to the designated holder. No owner, mint, burn, pause or blacklist.
contract KhanToken {
    string public constant name = "The Great Khan";
    string public constant symbol = "KHAN";
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply = 1_000_000_000 * 10 ** uint256(decimals);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    error ZeroAddress();
    error InsufficientBalance();
    error InsufficientAllowance();
    error AllowanceMustBeZeroFirst();

    constructor(address initialHolder) {
        if (initialHolder == address(0)) revert ZeroAddress();
        balanceOf[initialHolder] = totalSupply;
        emit Transfer(address(0), initialHolder, totalSupply);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    /// @dev Existing nonzero approvals must first be reset to zero to mitigate allowance races.
    /// Integrators must handle the two-step reset; this is stricter than common ERC-20 implementations.
    function approve(address spender, uint256 amount) external returns (bool) {
        if (spender == address(0)) revert ZeroAddress();
        if (amount != 0 && allowance[msg.sender][spender] != 0) revert AllowanceMustBeZeroFirst();
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        if (allowed < amount) revert InsufficientAllowance();
        if (allowed != type(uint256).max) {
            allowance[from][msg.sender] = allowed - amount;
            emit Approval(from, msg.sender, allowed - amount);
        }
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        if (to == address(0)) revert ZeroAddress();
        uint256 balance = balanceOf[from];
        if (balance < amount) revert InsufficientBalance();
        unchecked { balanceOf[from] = balance - amount; }
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
    }
}
