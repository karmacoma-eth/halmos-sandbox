// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test74 is Test {
    // Consider the following puzzle. 
    // Spend exactly 100 dollars and buy exactly 100 animals. 
    // Dogs cost 15 dollars, cats cost 1 dollar, and mice cost 25 cents each. 
    // You have to buy at least one of each. How many of each should you buy? 

    /// @custom:halmos --solver-timeout-assertion 0 --bvmul
    function test_dogCatMice(
        uint256 dogs,
        uint256 cats,
        uint256 mice
    ) external {
        vm.assume(dogs + cats + mice == 100);
        vm.assume(dogs > 0);
        vm.assume(cats > 0);
        vm.assume(mice > 0);

        assert(dogs * 1500 + cats * 100 + mice * 25 != 10000);
    }
}
