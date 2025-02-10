// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {SignatureChecker} from "openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";

contract ERC1271Check is Test {
    function returnsBytes4() external pure returns (bytes4) {
        return bytes4(0x1626ba7e);
    }

    function test_erc1271Check() external view {
        bool success =
            SignatureChecker.isValidERC1271SignatureNow({signer: address(4), hash: bytes32(0), signature: new bytes(0)});
        assert(success);
    }

    function test_erc1271Check_returnsBytes4() external view {
        (bool success, bytes memory result) = address(this).staticcall(abi.encodeWithSelector(this.returnsBytes4.selector));
        assertEq(result.length, 32);
    }
}
