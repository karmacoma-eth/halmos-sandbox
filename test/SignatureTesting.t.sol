pragma solidity ^0.8.21;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {console2} from "forge-std/console2.sol";
import {console} from "forge-std/console.sol";
import "forge-std/Test.sol";

contract TestingSignatureHalmos is Test, SymTest {
    address public constant EXPECTED_SIGNER = 0x1234519DCA2ef23207E1CA7fd70b96f281893bAa;

    function setUp() public {
        vm.warp(block.timestamp);
        vm.roll(300);
    }

    function halmos_signerAirdropShouldntBeReproducible() public {
        address msgSender = svm.createAddress("attacker");
        vm.assume(msgSender != address(0));

        bytes memory signature = svm.createBytes(65, "simulatedSignature");
        uint256 chainId = 1;
        bytes32 messageHash = keccak256(abi.encodePacked(chainId, msgSender));
        bytes32 r = slice32(signature, 0);
        bytes32 s = slice32(signature, 32);
        uint8 v = uint8(signature[64]);
        address recoveredAddress = ecrecover(messageHash, v, r, s);
        if (recoveredAddress == EXPECTED_SIGNER) {
            console2.log("Recovered address", recoveredAddress);
        }
        assertTrue(recoveredAddress != EXPECTED_SIGNER);
    }

    function halmos_signerAccessManagerShouldntBeReproducible() public {
        address msgSender = svm.createAddress("attacker");
        vm.assume(msgSender != address(0));

        uint256 geoVersion = svm.createUint256("geoVersion");
        bytes memory signature = svm.createBytes(65, "simulatedSignature");
        uint256 chainId = 1;
        bytes32 messageHash = keccak256(abi.encodePacked(chainId, geoVersion, msgSender));
        bytes32 r = slice32(signature, 0);
        bytes32 s = slice32(signature, 32);
        uint8 v = uint8(signature[64]);
        address recoveredAddress = ecrecover(messageHash, v, r, s);
        assertTrue(recoveredAddress != EXPECTED_SIGNER);
    }

    function slice32(bytes memory array, uint256 index) internal pure returns (bytes32 result) {
        result = 0;

        for (uint256 i = 0; i < 32; i++) {
            uint8 temp = uint8(array[index + i]);
            result |= bytes32((uint256(temp) & 0xFF) * 2 ** (8 * (31 - i)));
        }
    }
}
