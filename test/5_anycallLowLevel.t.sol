// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

// import Halmos cheatcodes
// import {SymTest} from "halmos-cheatcodes/SymTest.sol";

/// @notice Symbolic Virtual Machine
interface SVM {
    // Create a new symbolic uint value ranging over [0, 2**bitSize - 1] (inclusive)
    function createUint(uint256 bitSize, string memory name) external returns (uint256 value);

    // Create a new symbolic byte array with the given byte size
    function createBytes(uint256 byteSize, string memory name) external returns (bytes memory value);

    // Create a new symbolic uint256 value
    function createUint256(string memory name) external returns (uint256 value);

    // Create a new symbolic bytes32 value
    function createBytes32(string memory name) external returns (bytes32 value);

    // Create a new symbolic address value
    function createAddress(string memory name) external returns (address value);

    // Create a new symbolic boolean value
    function createBool(string memory name) external returns (bool value);
}

abstract contract SymTest {
    // SVM cheat code address: 0xf3993a62377bcd56ae39d773740a5390411e8bc9
    address internal constant SVM_ADDRESS = address(uint160(uint256(keccak256("svm cheat code"))));

    SVM internal constant svm = SVM(SVM_ADDRESS);
}

contract MockERC20 {
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = 1e27;
    }

    function transfer(address to, uint256 amount) public {
        _transfer(msg.sender, to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public {
        allowance[from][msg.sender] = allowance[from][msg.sender] - amount;
        _transfer(from, to, amount);
    }

    // oops, accidentally public
    function _transfer(address from, address to, uint256 amount) public {
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
    }

    function approve(address spender, uint256 amount) public {
        allowance[msg.sender][spender] = amount;
    }
}

contract Test5 is Test, SymTest {
    address owner = address(0xc0ffee);
    address badguy = address(0xdeadbeef);

    MockERC20 token;

    function setUp() public {
        vm.prank(owner);
        token = new MockERC20();
    }

    /// does not find the bug
    function test_anycallLowLevel(bytes calldata data) external {
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(badguy);
        (bool succ, bytes memory result) = address(token).call(data);

        uint256 balanceAfter = token.balanceOf(owner);
        assertEq(balanceBefore, balanceAfter);
    }

    /// finds the bug and generates a counterexample:
    ///     halmos_data_bytes_01 = 0x30e0789e00000000000000000000000000000000000000000000000000000000aaaa000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004
    function test_anycallLowLevelExplicit() external {
        bytes memory data = svm.createBytes(100, "data");
        uint256 balanceBefore = token.balanceOf(owner);

        vm.prank(badguy);
        (bool succ, bytes memory result) = address(token).call(data);

        uint256 balanceAfter = token.balanceOf(owner);
        assertEq(balanceBefore, balanceAfter);
    }
}
