// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Test112 is Test, SymTest {
    uint256 MEGA_SIZE = 10**32;

    function setUp() public {
        console2.log("Test112.setUp");
    }

    // good: reverts with Panic(0x41) (too much memory requested)
    // function test_megaMem_new_bytes() external {
    //     bytes memory data = new bytes(MEGA_SIZE);
    //     console2.logBytes(data);
    // }

    // bad: OverflowError: cannot fit 'int' into an index-sized integer
    function test_megaMem_sha3(bool coinflip) external {
        uint256 size = coinflip ? MEGA_SIZE : 32;

        assembly {
            let hash := keccak256(0, size)
        }
    }

    function test_megaMem_call_insize(bool coinflip) external {
        address addr = address(this);
        uint256 value = 0;
        bool success;
        uint256 in_ptr = 0;
        uint256 in_size = coinflip ? MEGA_SIZE : 32;
        uint256 out_ptr = 0;
        uint256 out_size = 0;

        assembly {
            success := call(gas(), addr, value, in_ptr, in_size, out_ptr, out_size)
        }
    }

    // // PASS
    // function test_megaMem_call_outsize() external {
    //     address addr = address(this);
    //     uint256 value = 0;
    //     bool success;
    //     uint256 in_ptr = 0;
    //     uint256 in_size = 0;
    //     uint256 out_ptr = 0;
    //     uint256 out_size = MEGA_SIZE;

    //     assembly {
    //         success := call(gas(), addr, value, in_ptr, in_size, out_ptr, out_size)
    //     }
    // }

    function test_megaMem_mcopy_srcoffset(bool coinflip) external {
        uint256 src_offset = coinflip ? MEGA_SIZE : 0;
        uint256 dst_offset = 0;
        uint256 size = 1;
        assembly {
            mcopy(dst_offset, src_offset, size)
        }
    }

    function test_megaMem_mcopy_dstoffset(bool coinflip) external {
        uint256 src_offset = 0;
        uint256 dst_offset = coinflip ? MEGA_SIZE : 0;
        uint256 size = 1;
        assembly {
            mcopy(dst_offset, src_offset, size)
        }
    }

    function test_megaMem_return(bool coinflip) external returns (bytes memory) {
        uint256 size = coinflip ? MEGA_SIZE : 32;
        assembly {
            return(0, size)
        }
    }

    function test_megaMem_log(bool coinflip) external {
        uint256 size = coinflip ? MEGA_SIZE : 32;
        assembly {
            log0(0, size)
        }
    }

    // TODO:
    // - MSTORE / MSTORE8
    // - MLOAD
    // - RETURNDATACOPY
    // - REVERT
    // - CALLDATACOPY
    // - CODECOPY
    // - EXTCODECOPY
    // - CREATE
    // - CREATE2
}
