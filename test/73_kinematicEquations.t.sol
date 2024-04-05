// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test73 is Test {
    function test_kinematicEquations(
        int256 displacement,
        int256 time,
        int256 initial_velocity,
        int256 final_velocity,
        int256 acceleration
    ) external {
        vm.assume(displacement == initial_velocity * time + (acceleration * time * time) / 2);
        vm.assume(final_velocity == initial_velocity + acceleration * time);

        // # Given v_i, v_f and a, find d
        // problem = [
        //     v_i == 30,
        //     v_f == 0,
        //     a   == -8
        // ]

        vm.assume(initial_velocity == 30);  // 30.00 m/s
        vm.assume(acceleration == -8);

        // can't find integer solution :(
        assert(final_velocity != 0); 
    }
}
