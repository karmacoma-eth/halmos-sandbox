// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import { SymTest } from "halmos-cheatcodes/SymTest.sol";
// import { TickMath } from "../../src/libraries/uniswap/TickMath.sol";

import { Test } from "forge-std/Test.sol";

// https://github.com/Uniswap/v3-core/blob/main/contracts/libraries/TickMath.sol

// @title Math library for computing sqrt prices from ticks and vice versa
/// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
/// prices between 2**-128 and 2**128
library TickMath {
    /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
    int24 internal constant MIN_TICK = -887272;
    /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
    int24 internal constant MAX_TICK = -MIN_TICK;

    /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
    uint160 internal constant MIN_SQRT_RATIO = 4295128739;
    /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
    uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;

    /// @notice Calculates sqrt(1.0001^tick) * 2^96
    /// @dev Throws if |tick| > max tick
    /// @param tick The input tick for the above formula
    /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
    /// at the given tick
    function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
        uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
        require(absTick <= uint256(int256(MAX_TICK)), 'T');

        uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
        if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
        if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
        if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
        if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
        if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
        if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
        if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
        if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
        if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
        if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
        if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
        if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
        if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
        if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
        if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
        if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
        if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
        if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
        if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;

        if (tick > 0) ratio = type(uint256).max / ratio;

        // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
        // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
        // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
        sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
    }

    /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
    /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
    /// ever return.
    /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
    /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
    function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
        // second inequality must be < because the price can never reach the price at the max tick
        require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
        uint256 ratio = uint256(sqrtPriceX96) << 32;

        uint256 r = ratio;
        uint256 msb = 0;

        assembly {
            let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(5, gt(r, 0xFFFFFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(4, gt(r, 0xFFFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(3, gt(r, 0xFF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(2, gt(r, 0xF))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := shl(1, gt(r, 0x3))
            msb := or(msb, f)
            r := shr(f, r)
        }
        assembly {
            let f := gt(r, 0x1)
            msb := or(msb, f)
        }

        if (msb >= 128) r = ratio >> (msb - 127);
        else r = ratio << (127 - msb);

        int256 log_2 = (int256(msb) - 128) << 64;

        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(63, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(62, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(61, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(60, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(59, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(58, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(57, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(56, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(55, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(54, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(53, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(52, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(51, f))
            r := shr(f, r)
        }
        assembly {
            r := shr(127, mul(r, r))
            let f := shr(128, r)
            log_2 := or(log_2, shl(50, f))
        }

        int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number

        int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
        int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);

        tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
    }
}


contract TickMathExposed {
    function getSqrtRatioAtTick(int24 tick) external pure returns (uint160 sqrtPriceX96) {
        sqrtPriceX96 = TickMath.getSqrtRatioAtTick(tick);
    }

    function getTickAtSqrtRatio(uint160 sqrtPriceX96) external pure returns (int24 tick) {
        tick = TickMath.getTickAtSqrtRatio(sqrtPriceX96);
    }
}

// This bytecode was compiled with 0.7.6, like the original Uniswap code
bytes constant tickMathExposedBytecode = hex"608060405234801561001057600080fd5b50610982806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80634f76c0581461003b578063986cfba314610096575b600080fd5b61007d6004803603602081101561005157600080fd5b81019080803573ffffffffffffffffffffffffffffffffffffffff1690602001909291905050506100f1565b604051808260020b815260200191505060405180910390f35b6100c5600480360360208110156100ac57600080fd5b81019080803560020b9060200190929190505050610103565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b60006100fc82610115565b9050919050565b600061010e82610511565b9050919050565b60006401000276a373ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff1610158015610197575073fffd8963efd1fc6a506488495d951d5263988d2673ffffffffffffffffffffffffffffffffffffffff168273ffffffffffffffffffffffffffffffffffffffff16105b610209576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260018152602001807f520000000000000000000000000000000000000000000000000000000000000081525060200191505060405180910390fd5b600060208373ffffffffffffffffffffffffffffffffffffffff16901b9050600081905060006fffffffffffffffffffffffffffffffff821160071b808217915082811c92505067ffffffffffffffff821160061b808217915082811c92505063ffffffff821160051b808217915082811c92505061ffff821160041b808217915082811c92505060ff821160031b808217915082811c925050600f821160021b808217915082811c9250506003821160011b808217915082811c92505060018211808217915050608081106102e757607f810383901c91506102f1565b80607f0383901b91505b6000604060808303901b9050828302607f1c92508260801c80603f1b8217915083811c935050828302607f1c92508260801c80603e1b8217915083811c935050828302607f1c92508260801c80603d1b8217915083811c935050828302607f1c92508260801c80603c1b8217915083811c935050828302607f1c92508260801c80603b1b8217915083811c935050828302607f1c92508260801c80603a1b8217915083811c935050828302607f1c92508260801c8060391b8217915083811c935050828302607f1c92508260801c8060381b8217915083811c935050828302607f1c92508260801c8060371b8217915083811c935050828302607f1c92508260801c8060361b8217915083811c935050828302607f1c92508260801c8060351b8217915083811c935050828302607f1c92508260801c8060341b8217915083811c935050828302607f1c92508260801c8060331b8217915083811c935050828302607f1c92508260801c8060321b82179150506000693627a301d71055774c8582029050600060806f028f6481ab7f045a5af012a19d003aaa8303901d9050600060806fdb2df09e81959a81455e260799a0632f8401901d90508060020b8260020b14610501578873ffffffffffffffffffffffffffffffffffffffff166104d882610511565b73ffffffffffffffffffffffffffffffffffffffff1611156104fa57816104fc565b805b610503565b815b975050505050505050919050565b60008060008360020b12610528578260020b610530565b8260020b6000035b90507ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff2761860000360020b8111156105ce576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260018152602001807f540000000000000000000000000000000000000000000000000000000000000081525060200191505060405180910390fd5b6000806001831614156105f257700100000000000000000000000000000000610604565b6ffffcb933bd6fad37aa2d162d1a5940015b70ffffffffffffffffffffffffffffffffff1690506000600283161461063e5760806ffff97272373d413259a46990580e213a8202901c90505b600060048316146106635760806ffff2e50f5f656932ef12357cf3c7fdcc8202901c90505b600060088316146106885760806fffe5caca7e10e4e61c3624eaa0941cd08202901c90505b600060108316146106ad5760806fffcb9843d60f6159c9db58835c9266448202901c90505b600060208316146106d25760806fff973b41fa98c081472e6896dfb254c08202901c90505b600060408316146106f75760806fff2ea16466c96a3843ec78b326b528618202901c90505b6000608083161461071c5760806ffe5dee046a99a2a811c461f1969c30538202901c90505b60006101008316146107425760806ffcbe86c7900a88aedcffc83b479aa3a48202901c90505b60006102008316146107685760806ff987a7253ac413176f2b074cf7815e548202901c90505b600061040083161461078e5760806ff3392b0822b70005940c7a398e4b70f38202901c90505b60006108008316146107b45760806fe7159475a2c29b7443b29c7fa6e889d98202901c90505b60006110008316146107da5760806fd097f3bdfd2022b8845ad8f792aa58258202901c90505b60006120008316146108005760806fa9f746462d870fdf8a65dc1f90e061e58202901c90505b60006140008316146108265760806f70d869a156d2a1b890bb3df62baf32f78202901c90505b600061800083161461084c5760806f31be135f97d08fd981231505542fcfa68202901c90505b6000620100008316146108735760806f09aa508b5b7a84e1c677de54f3e99bc98202901c90505b6000620200008316146108995760806e5d6af8dedb81196699c329225ee6048202901c90505b6000620400008316146108be5760806d2216e584f5fa1ea926041bedfe988202901c90505b6000620800008316146108e15760806b048a170391f7dc42444e8fa28202901c90505b60008460020b131561091a57807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff8161091657fe5b0490505b6000640100000000828161092a57fe5b061461093757600161093a565b60005b60ff16602082901c019250505091905056fea26469706673582212208f2a5bd07e0b21473d567717e67955d46200a4804474da3044141b2806638fe964736f6c63430007060033";

/**
 * @dev Diff test TickMath compiled with 0.7.6 vs compiled with 0.8.21
 */
/// @custom:halmos --solver-timeout-assertion 0
contract UniswapTickMath_DifferentialTest is SymTest, Test {
    TickMathExposed ionTickMath;
    TickMathExposed originalTickMath;

    function setUp() external {
        // Compiled with 0.8.21
        ionTickMath = new TickMathExposed();

        bytes memory originalTickMathBytecode = tickMathExposedBytecode;
        assembly {
            let deployedAddr := create(0, add(originalTickMathBytecode, 0x20), mload(originalTickMathBytecode))
            sstore(originalTickMath.slot, deployedAddr)
        }
    }

    function testDifferential_GetSqrtRatioAtTick(int24 tick) external {
        vm.assume(tick >= TickMath.MIN_TICK && tick <= TickMath.MAX_TICK);
        vm.assume(tick >= 0 && tick <= 255);


        uint160 ionSqrtPriceX96 = ionTickMath.getSqrtRatioAtTick(tick);
        uint160 originalSqrtPriceX96 = originalTickMath.getSqrtRatioAtTick(tick);
        assert(ionSqrtPriceX96 == originalSqrtPriceX96);
    }

    function testDifferential_GetTickAtSqrtRatio(uint160 sqrtPriceX96) external {
        vm.assume(sqrtPriceX96 >= TickMath.MIN_SQRT_RATIO && sqrtPriceX96 < TickMath.MAX_SQRT_RATIO);

        int24 ionTick = ionTickMath.getTickAtSqrtRatio(sqrtPriceX96);
        int24 originalTick = originalTickMath.getTickAtSqrtRatio(sqrtPriceX96);
        assert(ionTick == originalTick);
    }
}
