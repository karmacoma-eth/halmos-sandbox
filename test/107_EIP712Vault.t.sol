// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {EIP712} from "solady/src/utils/EIP712.sol";
import {ECDSA} from "solady/src/utils/ECDSA.sol";

import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

event Transfer(address from, address to, uint256 amount);

/// a request to withdraw some amount of ether to some recipient
/// @dev (not including a deadline for simplicity)
struct Request {
    address depositor;
    address recipient;
    uint256 amount;
}

contract EIP712Vault is EIP712 {
    bytes32 private constant _REQUEST_TYPEHASH = keccak256("Request(address depositor,address recipient,uint256 amount)");

    /// mutable storage
    mapping(address => uint256) public balances;


    function deposit() external payable {
        // don't emit events for 0 value
        if (msg.value == 0) {
            return;
        }

        emit Transfer(msg.sender, address(this), msg.value);

        balances[msg.sender] += msg.value;
    }

    /// direct withdrawal by depositor
    function withdraw(uint256 amount) external {
        // we rely on msg.sender for authentication
        _execute(Request({depositor: msg.sender, recipient: msg.sender, amount: amount}));
    }

    /// delegated withdrawal by signature, lets anyone withdraw from some depositor given a signed authorization
    ///
    /// @param request the request to execute
    /// @param signature an EIP-712 signature for the request by the depositor
    function withdraw(Request memory request, bytes memory signature) external {
        // verify the signature
        bytes32 digest = _hashTypedData(getDataHash(request));
        address signer = ECDSA.recover(digest, signature);

        if (signer != request.depositor) {
            revert("wrong signer");
        }

        // execute the Request
        _execute(request);
    }

    /// internal stuffs

    /// @dev performs no auth checks, assumes the request is valid
    function _execute(Request memory request) internal {
        // reverts if underflow
        balances[request.depositor] -= request.amount;

        emit Transfer(address(this), request.recipient, request.amount);

        (bool success,) = request.recipient.call{value: request.amount}("");
        require(success, "transfer failed");
    }

    function _domainNameAndVersion()
        internal
        view
        virtual
        override
        returns (string memory name, string memory version)
    {
        name = "EIP712Vault";
        version = "1";
    }


    function getDataHash(Request memory request) public pure returns (bytes32) {
        return keccak256(
            abi.encode(
                _REQUEST_TYPEHASH,
                request.depositor,
                request.recipient,
                request.amount
            )
        );
    }

    function domainSeparator() public view returns (bytes32) {
        return _domainSeparator();
    }
}


contract EIP712VaultHalmosTest is Test, SymTest {
    EIP712Vault public vault;
    address public depositor;
    uint256 private depositorPk;

    address public attacker;

    function setUp() public {
        vault = new EIP712Vault();

        depositorPk = svm.createUint256("depositorPk");
        depositor = vm.addr(depositorPk);
        attacker = svm.createAddress("attacker");

        vm.deal(depositor, 1 ether);
        vm.prank(depositor);
        vault.deposit{value: 1 ether}();
    }

    /// can halmos come up with a symbolic request and signature that allows an attacker to withdraw from the vault?
    /// answer: kind of -- but the counterexamples are not super useful
    /// (halmos just explores both sides of the `if (signer != request.depositor)` check)
    function check_delegatedWithdrawal(Request memory request, bytes memory signature) external {
        vm.deal(attacker, 0);

        vault.withdraw(request, signature);

        assertEq(address(attacker).balance, 0);
    }
}


// foundry tests to verify the basic functionality of the EIP712Vault
contract EIP712VaultFoundryTest is Test {
    EIP712Vault public vault;

    function setUp() public {
        console2.log("Test107.setUp");
        vault = new EIP712Vault();

        // deposit 1 ether
        vm.deal(address(this), 1 ether);
        vault.deposit{value: 1 ether}();
    }

    receive() external payable {}

    function test_sanity_directWithdrawal() external {
        vault.withdraw(1 ether);

        assertEq(address(vault).balance, 0);
        assertEq(address(this).balance, 1 ether);
    }

    function test_sanity_delegatedWithdrawal() external {
        uint256 initialVaultBalance = address(vault).balance;

        // conjure up a signer
        uint256 pk = 42;
        address signer = vm.addr(pk);
        vm.label(signer, "signer");

        // make them depositors
        vm.deal(signer, 1 ether);

        vm.prank(signer);
        vault.deposit{value: 1 ether}();

        // check the transfer worked
        assertEq(address(vault).balance, initialVaultBalance + 1 ether);
        assertEq(address(signer).balance, 0);

        // have them withdraw by signature
        Request memory request = Request({depositor: signer, recipient: address(this), amount: 1 ether});
        bytes32 requestHash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                vault.domainSeparator(),
                vault.getDataHash(request)
            )
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, requestHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vault.withdraw(request, signature);

        // check the transfer worked
        assertEq(address(vault).balance, initialVaultBalance);
        assertEq(address(this).balance, 1 ether);
    }
}
