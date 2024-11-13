// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {FixedPointMathLib} from "solady/utils/FixedPointMathLib.sol";

contract Bomber {
    uint256 internal constant FREE_MEM_PTR = 0x40;
    uint256 internal constant WORD_SIZE = 32;
    uint256 internal constant ERROR_STRING_SELECTOR = 0x08c379a0; // Error(string)

    /// calculate the memory size in words required to trigger a given memory expansion cost
    function calculateMemorySizeWord(uint memory_cost) public pure returns (uint memory_size_word) {
        // Constants for the quadratic equation
        uint a = 1;
        uint b = 1536; // 3 * 512
        uint c = 512 * memory_cost;

        // Calculate the discriminant
        uint discriminant = b**2 + 4 * a * c;

        // Calculate the positive root using the quadratic formula
        memory_size_word = FixedPointMathLib.sqrt(discriminant) / (2 * a) - b;
    }

    function bomb() external view {
        // we need to pay the memory expansion cost, so we need to return a large string
        // that uses as much gas as possible without actually running out of gas

        // let's use approximately 90% of the gas we have available
        uint256 bomb_length = calculateMemorySizeWord(gasleft() * 9 / 10) * WORD_SIZE;
        uint256 payload_length = 4 + 2 * WORD_SIZE + bomb_length;

        assembly {
            let ptr := mload(FREE_MEM_PTR)
            mstore(ptr, shl(224, ERROR_STRING_SELECTOR))
            mstore(add(ptr, 0x04), WORD_SIZE) // String offset
            mstore(add(ptr, 0x24), bomb_length) // String length
            mstore(add(ptr, 0x44), "BOMB!")
            revert(ptr, payload_length)
        }
    }
}

contract Victim {
    event CaughtBomb();
    event CaughtBombWithSignature(uint256 signature);

    Bomber bomber = new Bomber();

    function noProtection() external view {
        // we just revert because the bomber reverts, no revert data is used
        bomber.bomb();
    }

    // ✅ safe
    function tryCatchBasic() external {
        try bomber.bomb() {
            // unreachable
        } catch {
            emit CaughtBomb();
        }
    }

    // ❌ unsafe -- the bomb is an Error(string), so this definitely tries to load/parse the revert data
    function tryCatchErrorString() external {
        try bomber.bomb() {
            // unreachable
        } catch Error(string memory reason) {
            // should not be triggered, not returning a string
            emit CaughtBomb();
        }
    }

    // ❌ unsafe -- even though the error is unrelated
    function tryCatchUnrelatedError() external {
        try bomber.bomb() {
            // unreachable
        } catch Panic(uint256 code) {
            // should not be triggered, not returning a string
            emit CaughtBombWithSignature(code);
        }
    }

    // ❌ unsafe (some future compiler version could avoid copying the revert data to memory if it's unused)
    function tryCatchBytes() external {
        try bomber.bomb() {
            // unreachable
        } catch (bytes memory revertdata) {
            emit CaughtBomb();
        }
    }

    // ❌ unsafe, even though we use only a fixed size part of the revert data
    function tryCatchBytesPrefixUsed() external {
        try bomber.bomb() {
            // unreachable
        } catch (bytes memory revertdata) {
            emit CaughtBombWithSignature(uint256(bytes32(revertdata)));
        }
    }

    // ❌ unsafe (some future compiler version could avoid copying the revert data to memory if it's unused)
    function lowLevelWithBytesUnused() external {
        (bool success, bytes memory revertdata) = address(bomber).call(abi.encodeWithSignature("bomb()"));
        if (!success) {
            emit CaughtBomb();
        }
    }

    // ❌ unsafe, even though we use only a fixed size part of the revert data
    function lowLevelWithBytesPrefixUsed() external {
        (bool success, bytes memory revertdata) = address(bomber).call(abi.encodeWithSignature("bomb()"));
        if (!success) {
            emit CaughtBombWithSignature(uint256(bytes32(revertdata)));
        }
    }

    // ❌ unsafe (some future compiler version could avoid copying the revert data to memory if it's unused)
    function lowLevelIgnoringData() external {
        (bool success, ) = address(bomber).call(abi.encodeWithSignature("bomb()"));
        if (!success) {
            emit CaughtBomb();
        }
    }

    // ✅ safe, we explicitly requested 0 bytes to be copied from the revert data
    // see https://github.com/nomad-xyz/ExcessivelySafeCall for a wrapper library that does this
    function excessivelySafeCall() external {
        bytes memory _calldata = abi.encodeWithSignature("bomb()");
        address _recipient = address(bomber);

        bool success;

        assembly {
            success := call(
                gas(),
                _recipient,
                0, // ether value
                add(_calldata, 0x20), // inloc
                mload(_calldata), // inlen
                0, // outloc
                0 // outlen
            )
        }

        if (!success) {
            emit CaughtBomb();
        }
    }

    function summary() external {
        // ✅ safe
        try bomber.bomb() {} catch {
            emit CaughtBomb();
        }

        // ✅ safe
        address target = address(bomber);
        bytes memory data = abi.encodeWithSignature("bomb()");
        assembly {
            let success := call(gas(), target, 0, add(data, 0x20), mload(data), 0, 0)
            if iszero(success) {
                revert(0, 0)
            }
        }

        /*//////////////////////////////////////////////////////////////
                        ❌❌❌ NOW ENTERING UNSAFE LAND ❌❌❌
        //////////////////////////////////////////////////////////////*/

        // ❌ any try catch that accesses the revert data is unsafe
        try bomber.bomb() {} catch (bytes memory revertdata) {}

        // ❌ any low level call even if it doesn't access the revert data is unsafe
        (bool success, ) = address(bomber).call(abi.encodeWithSignature("bomb()"));
    }
}

contract TestReturnBomb is Test {
    Victim victim;
    uint256 constant GAS_STIPEND = 1_000_000;

    function setUp() public {
        victim = new Victim();
    }

    function test_noProtection() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("noProtection()"));
        assertTrue(succ);
    }

    function test_tryCatchBasic() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("tryCatchBasic()"));
        assertTrue(succ);
    }

    function test_tryCatchErrorString() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("tryCatchErrorString()"));
        assertTrue(succ);
    }

    function test_tryCatchUnrelatedError() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("tryCatchUnrelatedError()"));
        assertTrue(succ);
    }

    function test_tryCatchBytes() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("tryCatchBytes()"));
        assertTrue(succ);
    }

    function test_tryCatchBytesPrefixUsed() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("tryCatchBytesPrefixUsed()"));
        assertTrue(succ);
    }

    function test_lowLevelWithBytes() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("lowLevelWithBytesUnused()"));
        assertTrue(succ);
    }

    function test_lowLevelWithBytesPrefixUsed() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("lowLevelWithBytesPrefixUsed()"));
        assertTrue(succ);
    }

    function test_lowLevelIgnoringData() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("lowLevelIgnoringData()"));
        assertTrue(succ);
    }

    function test_excessivelySafeCall() external {
        (bool succ,) = address(victim).call{gas: GAS_STIPEND}(abi.encodeWithSignature("excessivelySafeCall()"));
        assertTrue(succ);
    }
}

