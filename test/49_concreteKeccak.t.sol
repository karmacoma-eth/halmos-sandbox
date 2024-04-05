// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "forge-std/Test.sol";

contract Test49 is Test {
    function test_concreteKeccak_up() external {
        bytes32 hash = keccak256(abi.encodePacked(uint256(3)));
        uint256 bit = uint256(hash) & 1;

        if (uint256(hash) & 1 == 0) {
            console2.log("even");
        } else {
            console2.log("odd");
        }
    }

    function test_concreteKeccak_lookup() external {
        bytes32 hash = keccak256(abi.encodePacked(uint256(3)));
        uint256 bit = uint256(hash) & 1;

        string[] memory x = new string[](2);
        x[0] = "even";
        x[1] = "odd";

        console2.log(x[bit]);
    }
}
