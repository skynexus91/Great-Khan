// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;
import "../src/KhanMultisig.sol";
import "../src/KhanToken.sol";

interface VmSigners { function prank(address) external; function warp(uint256) external; }

contract KhanMultisigTest {
    VmSigners private constant vm = VmSigners(address(uint160(uint256(keccak256("hevm cheat code")))));
    address constant S1 = address(0x101);
    address constant S2 = address(0x102);
    address constant S3 = address(0x103);
    address constant S4 = address(0x104);
    address constant S5 = address(0x105);
    address constant OUTSIDER = address(0x999);
    KhanMultisig wallet;
    KhanToken token;

    function setUp() public {
        address[5] memory owners = [S1, S2, S3, S4, S5];
        wallet = new KhanMultisig(owners);
        token = new KhanToken(address(this), address(wallet), S5, address(0xCA57));
    }

    function _proposal(address target, bytes memory data) internal returns (uint256 id) {
        vm.prank(S1);
        id = wallet.propose(target, data);
    }

    function _approve(uint256 id) internal {
        vm.prank(S2);
        wallet.confirm(id);
        vm.prank(S3);
        wallet.confirm(id);
    }

    function testFiveDistinctSignersThreeRequired() public {
        require(wallet.REQUIRED() == 3);
        require(wallet.SIGNER_COUNT() == 5);
        require(wallet.isSigner(S1) && wallet.isSigner(S5));
        require(!wallet.isSigner(OUTSIDER));
    }

    function testRejectDuplicateAndZeroSigners() public {
        address[5] memory owners = [S1, S2, S3, S4, S1];
        bool reverted;
        try new KhanMultisig(owners) returns (KhanMultisig) {} catch { reverted = true; }
        require(reverted, "duplicate signer accepted");
        owners[4] = address(0);
        reverted = false;
        try new KhanMultisig(owners) returns (KhanMultisig) {} catch { reverted = true; }
        require(reverted, "zero signer accepted");
    }

    function testTwoApprovalsCannotExecute() public {
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.pause, ()));
        vm.prank(S2);
        wallet.confirm(id);
        vm.prank(S1);
        bool reverted;
        try wallet.execute(id) returns (bytes memory) {} catch { reverted = true; }
        require(reverted, "2 of 5 bypass");
        require(!token.paused());
    }

    function testThreeApprovalsExecuteOnlyOnce() public {
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.unpause, ()));
        _approve(id);
        vm.prank(S4);
        wallet.execute(id);
        bool reverted;
        vm.prank(S4);
        try wallet.execute(id) returns (bytes memory) {} catch { reverted = true; }
        require(reverted, "replay succeeded");
    }

    function testMultisigControlsTokenMintWithDelay() public {
        bytes32 caseId = keccak256("multisig-mint");
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.queueMint, (caseId, OUTSIDER, 100 ether)));
        _approve(id);
        vm.prank(S4);
        wallet.execute(id);
        require(token.totalSupply() == 1_000_000_000 ether);
        vm.warp(block.timestamp + 2 days);
        uint256 executeId = _proposal(address(token), abi.encodeCall(KhanToken.executeMint, (caseId, OUTSIDER, 100 ether)));
        _approve(executeId);
        vm.prank(S5);
        wallet.execute(executeId);
        require(token.balanceOf(OUTSIDER) == 100 ether);
        require(token.totalSupply() == 1_000_000_100 ether);
    }

    function testRevokeDropsBelowThreshold() public {
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.unpause, ()));
        _approve(id);
        vm.prank(S3);
        wallet.revoke(id);
        vm.prank(S4);
        bool reverted;
        try wallet.execute(id) returns (bytes memory) {} catch { reverted = true; }
        require(reverted, "revocation ignored");
    }

    function testNonSignerCannotApproveOrPropose() public {
        vm.prank(OUTSIDER);
        bool reverted;
        try wallet.propose(address(token), abi.encodeCall(KhanToken.pause, ())) returns (uint256) {} catch { reverted = true; }
        require(reverted, "outsider proposed");
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.pause, ()));
        vm.prank(OUTSIDER);
        reverted = false;
        try wallet.confirm(id) {} catch { reverted = true; }
        require(reverted, "outsider confirmed");
    }

    function testSignerRotationInvalidatesPendingProposals() public {
        uint256 staleId = _proposal(address(token), abi.encodeCall(KhanToken.pause, ()));
        uint256 rotateId = _proposal(address(wallet), abi.encodeCall(KhanMultisig.replaceSigner, (S5, OUTSIDER)));
        _approve(rotateId);
        vm.prank(S4);
        wallet.execute(rotateId);
        require(wallet.isSigner(OUTSIDER) && !wallet.isSigner(S5));
        vm.prank(S2);
        bool reverted;
        try wallet.confirm(staleId) {} catch { reverted = true; }
        require(reverted, "stale proposal survived");
    }

    function testFailedTargetCallDoesNotConsumeTransaction() public {
        uint256 id = _proposal(address(token), abi.encodeCall(KhanToken.executeMint, (bytes32(uint256(1)), OUTSIDER, 1)));
        _approve(id);
        vm.prank(S4);
        bool reverted;
        try wallet.execute(id) returns (bytes memory) {} catch { reverted = true; }
        require(reverted, "failed target accepted");
        (,,,bool executed,) = wallet.getTransaction(id);
        require(!executed, "failed execution consumed");
    }
}
