// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Target {
    mapping(address => uint256) public balanceOf;
    uint256 public totalSupply;

    constructor(uint256 _totalSupply) {
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address to, uint256 amount) external {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
    }
}

contract Test59 is Test, SymTest {
    Target target;
    uint256 initialSupply;

    function setUp() public {
        initialSupply = svm.createUint256("totalSupply");
        target = new Target(initialSupply);
    }

    function mk_call(address target) internal {
        address sender = svm.createAddress("sender");
        bytes memory data = svm.createBytes(68, "calldata");

        vm.prank(sender);
        (bool succ,) = target.call(data);

        vm.assume(succ);
    }

    function test_arbitraryCalls() external {
        mk_call(address(target));
        mk_call(address(target));
        mk_call(address(target));
        assertEq(target.totalSupply(), initialSupply, "invariant still holds after 3 arbitrary calls to target");
    }
}
