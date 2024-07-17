// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

/// Test the output shape of a function
contract Test77 is Test, SymTest {
    function max(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a > _b ? _a : _b;
    }

    function min(uint256 _a, uint256 _b) internal pure returns (uint256) {
        return _a < _b ? _a : _b;
    }

    /// @dev we want to check that the output of foo conforms to some shape
    /// without necessarily knowing exactly the implementation of _bar:
    /// - foo(x) should be in the expected range
    /// - foo should be monotonically increasing (but not strictly increasing)
    /// - foo should not be constant
    function foo(uint256 x) public pure returns (uint256 y) {
        return min(_bar(x), type(uint16).max);
    }

    function _bar(uint256 x) internal pure returns (uint256 b) {
        // b = x ** 2; // case 1
        // b = x ** 3; // case 2
        b = x ** 4; // case 3
        // b = log(x); // case 4
        // b = log(x * 100); // case 5
        // b = x + 1; // case 6
    }

    function check_foo() external {
        _check_function_monotonic(foo);
    }

    /// @dev f may be constant
    function _check_function_monotonic(function(uint256) internal pure returns(uint256) f) internal {
        uint256 x = svm.createUint256("x");

        assertLe(f(x), f(x + 1));
    }

    /// @dev implies f is not constant
    function _check_function_strictlyMonotonic(function(uint256) internal pure returns(uint256) f) internal {
        uint256 x = svm.createUint256("x");

        assertLt(f(x), f(x + 1));
    }

    function _check_function_injective(function(uint256) internal pure returns(uint256) f) internal {
        uint256 x = svm.createUint256("x");
        uint256 y = svm.createUint256("y");

        assertNotEq(f(x), f(y));
    }

    /// we want to check that for all y in [lower..upper], there exists some x such that f(x) = y
    function _check_function_surjective(function(uint256) internal pure returns(uint256) f, uint256 lower, uint256 upper) internal {
        /// TBD
    }

    /// @dev we want to check that there exists some (x, y) s.t. f(x) != f(y)
    /// @dev UX is not great, if the function is indeed not constant it will print 'fail' along with the cex
    /// (in this case, the cex is what we want, it successfully found (x, y) such that f(x) != f(y))
    function _check_function_notConstant(function(uint256) internal pure returns(uint256) f) internal {
        uint256 x = svm.createUint256("x");
        uint256 y = svm.createUint256("y");
        vm.assume(x != y);

        assertEq(f(x), f(y));
    }

    function _check_function_constant(function(uint256) internal pure returns(uint256) f) internal {
        uint256 x = svm.createUint256("x");
        vm.assume(x != 0);

        assertEq(f(x), f(0));
    }
}
