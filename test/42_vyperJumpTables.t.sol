// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/test.sol";
import {console} from "forge-std/console.sol";

contract FormalTests is Test {
    function testFormal__Storage(uint256 init1, bytes4 sel, uint256 val, uint256 arg1) public {
        address old;
        address unopt;
        address gasopt;
        address sizeopt;

        {
            bytes memory old_bc =
                hex"60206100a15f395f5180600f0b811861009d576040523461009d576040515f5561006d61002f60003961006d6000f36003361161000c57610058565b5f3560e01c3461005c57632a1afcd9811861002c575f5460405260206040f35b63795313b08118610056576024361061005c5760043580600f0b811861005c576040526040515f55005b505b5f5ffd5b5f80fda165767970657283000309000b005b5f80fd";
            bytes memory unopt_bc =
                hex"3415156100445761000b565b60205f5f016100f3015f395f5180600f0b811415610044578090506040526040515f55610033565b6100996100486000396100996000f3005b5f80fd600436101561000d57610090565b5f3560e01c632a1afcd9811415610046573415156100955760043610151561009557610034565b5f545f6040015260206040610044565bf35b63795313b081141561008a573415156100955760243610151561009557610068565b5f6004013580600f0b811415610095578090506040526040515f55610088565b005b50610090565b5f5ffd005b5f80fd8418998000a16576797065728300030a0012";
            bytes memory gasopt_bc =
                hex"3461002f5760206100b55f395f5180600f0b811861002f576040526040515f5561006f61003360003961006f6000f35b5f80fd5f3560e01c60026001821660011b61006b01601e395f51565b632a1afcd981186100635734610067575f5460405260206040f3610063565b63795313b08118610063576024361034176100675760043580600f0b8118610067576040526040515f55005b5f5ffd5b5f80fd0037001884186f810400a16576797065728300030a0013";
            bytes memory sizeopt_bc =
                hex"3461002f5760206100b55f395f5180600f0b811861002f576040526040515f5561006f61003360003961006f6000f35b5f80fd5f3560e01c60026001821660011b61006b01601e395f51565b632a1afcd981186100635734610067575f5460405260206040f3610063565b63795313b08118610063576024361034176100675760043580600f0b8118610067576040526040515f55005b5f5ffd5b5f80fd0037001884186f810400a16576797065728300030a0013";

            old_bc = abi.encodePacked(old_bc, abi.encode(init1));
            unopt_bc = abi.encodePacked(unopt_bc, abi.encode(init1));
            gasopt_bc = abi.encodePacked(gasopt_bc, abi.encode(init1));
            sizeopt_bc = abi.encodePacked(sizeopt_bc, abi.encode(init1));

            assembly {
                old := create(0, add(old_bc, 0x20), mload(old_bc))
                unopt := create(0, add(unopt_bc, 0x20), mload(unopt_bc))
                gasopt := create(0, add(gasopt_bc, 0x20), mload(gasopt_bc))
                sizeopt := create(0, add(sizeopt_bc, 0x20), mload(sizeopt_bc))
            }
        }

        bytes memory cd = abi.encodePacked(sel, arg1);

        (bool old_s, bytes memory old_d) = old.call{value: val}(cd);
        (bool unopt_s, bytes memory unopt_d) = unopt.call{value: val}(cd);
        (bool gasopt_s, bytes memory gasopt_d) = gasopt.call{value: val}(cd);
        (bool sizeopt_s, bytes memory sizeopt_d) = sizeopt.call{value: val}(cd);

        assert(old_s == unopt_s && old_s == gasopt_s && old_s == sizeopt_s);
        assert(
            keccak256(old_d) == keccak256(unopt_d) && keccak256(old_d) == keccak256(gasopt_d)
                && keccak256(old_d) == keccak256(sizeopt_d)
        );
    }
}
