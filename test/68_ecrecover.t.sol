// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract Test68 is Test {
    uint256 constant secp256k1n = 115792089237316195423570985008687907852837564279074904382605163141518161494337;

    function test_ecrecover_sol() external {
        uint256 s = 0x4f8ae3bd7535248d0bd448298cc2e2071e56992d0774dc340c368ae950852ada;
        address addr = ecrecover(
                0x456e9aea5e197a1f1af7a3e85a3212fa4049a3ba34c2289b4c860fc0b0c64ef3, // hash
                28, // v
                0x9242685bf161793cc25603c231bc2f568eb630ea16aa137d2664ac8038825608,  // r
                bytes32(s)
            );

        assertEq(addr, 0x7156526fbD7a3C72969B54f64e42c10fbb768C8a);

        address addr2 = ecrecover(
                0x456e9aea5e197a1f1af7a3e85a3212fa4049a3ba34c2289b4c860fc0b0c64ef3, // hash
                27, // v
                0x9242685bf161793cc25603c231bc2f568eb630ea16aa137d2664ac8038825608,  // r
                bytes32(secp256k1n - s)  // malleability ftw
            );

        assertEq(addr, addr2);
    }

    function test_ecrecover_yul() external {
        bytes32 digest = 0x456e9aea5e197a1f1af7a3e85a3212fa4049a3ba34c2289b4c860fc0b0c64ef3;
        uint8 v = 28;
        bytes32 r = 0x9242685bf161793cc25603c231bc2f568eb630ea16aa137d2664ac8038825608;
        bytes32 s = 0x4f8ae3bd7535248d0bd448298cc2e2071e56992d0774dc340c368ae950852ada;
        bytes memory data = abi.encode(digest, v, r, s);

        bool succ;
        address addr;

        assembly {
            succ := staticcall(
                gas(),
                0x1,
                add(data, 0x20),  // inputOffset
                mload(data),  // inputSize,
                0,  // output,
                16  // outputSize)
            )

            addr := mload(0)
        }

        console.log(succ);
        console.log(addr);
    }

    // function test_ecrecover_sol_badS() external {
    //     address addr = ecrecover(
    //             0x456e9aea5e197a1f1af7a3e85a3212fa4049a3ba34c2289b4c860fc0b0c64ef3, // hash
    //             28, // v
    //             0x9242685bf161793cc25603c231bc2f568eb630ea16aa137d2664ac8038825608,  // r
    //             bytes32(secp256k1n)  // s
    //         );
    //     assertEq(addr, 0x7156526fbD7a3C72969B54f64e42c10fbb768C8a);
    // }
}
