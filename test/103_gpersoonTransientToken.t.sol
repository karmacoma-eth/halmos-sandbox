// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "openzeppelin-contracts/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract token is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}
}

contract transientImplementation {
    function(string memory) returns (bytes32) immutable load;
    function(string memory, bytes32) immutable store;

    function getSlot(string memory s) internal pure returns (bytes32) {
        return bytes32(uint256(keccak256(bytes(s))) - 1);
    }

    function tstore(string memory s, bytes32 value) internal {
        bytes32 a = getSlot(s);
        assembly {
            tstore(a, value)
        }
    }

    function sstore(string memory s, bytes32 value) internal {
        bytes32 a = getSlot(s);
        assembly {
            sstore(a, value)
        }
    }

    function tload(string memory s) internal view returns (bytes32 value) {
        bytes32 a = getSlot(s);
        assembly {
            value := tload(a)
        }
    }

    function sload(string memory s) internal view returns (bytes32 value) {
        bytes32 a = getSlot(s);
        assembly {
            value := sload(a)
        }
    }

    function tempStoreKeyValue(string memory key, bytes32 value) public {
        store(key, value);
    }

    function tempGetValue(string memory key) public returns (bytes32 value) {
        return load(key);
    }

    function toString(bytes32 _bytes32) internal pure returns (string memory) {
        uint8 i;
        while (i < 32 && _bytes32[i] != 0) i++;
        bytes memory bytesArray = new bytes(i);
        for (i = 0; i < 32 && _bytes32[i] != 0; i++) {
            bytesArray[i] = _bytes32[i];
        }
        return string(bytesArray);
    }

    function deployToken() public returns (address) {
        string memory name = toString(tempGetValue("name"));
        string memory symbol = toString(tempGetValue("symbol"));
        console.log("name", name);
        console.log("symbol", symbol);
        token t = new token(name, symbol);
        return address(t);
    }

    constructor(bool _hasTrancient) {
        // not every chain supports transient storage, fallback via storage
        (load, store) = _hasTrancient ? (tload, tstore) : (sload, sstore);
    }
}

abstract contract TestProxy is Test, SymTest {
    function proxy() public view virtual returns (TransparentUpgradeableProxy);

    function admin(TransparentUpgradeableProxy p) internal view returns (address) {
        uint256 slot = uint256(keccak256("eip1967.proxy.admin")) - 1;
        return address(uint160(uint256(vm.load(address(p), bytes32(slot)))));
    }

    function test_non_admin_can_not_update_admin() public {
        address sender = svm.createAddress("sender");

        TransparentUpgradeableProxy p = proxy();
        console.log("proxy", address(p));

        address adminBefore = admin(p);
        console.log("adminBefore", adminBefore);

        // TODO: uncomment when we have confirmed that the test works
        // vm.assume(adminBefore != sender);

        bytes memory data = svm.createCalldata("transientImplementation");

        vm.prank(sender);
        (bool succ,) = address(p).call(data);
        vm.assume(succ);

        address adminAfter = admin(p);
        assertEq(adminBefore, adminAfter);
    }
}

contract TestTransient is TestProxy {
    // use the fancy new TSTORE/TLOAD opcodes
    transientImplementation _implementation = new transientImplementation(true);
    transientImplementation _proxy =
        transientImplementation(address(new TransparentUpgradeableProxy(address(_implementation), address(this), "")));

    function setUp() public {
        _proxy.tempStoreKeyValue("name", "Token name");
        _proxy.tempStoreKeyValue("symbol", "Token symbol");
        _proxy.deployToken();
    }

    function proxy() public view override returns (TransparentUpgradeableProxy) {
        return TransparentUpgradeableProxy(payable(address(_proxy)));
    }
}

contract TestNotTransient is TestProxy {
    // use the old SSTORE/SLOAD opcodes (for chains that don't support transient storage)
    transientImplementation _implementation = new transientImplementation(false);
    transientImplementation _proxy =
        transientImplementation(address(new TransparentUpgradeableProxy(address(_implementation), address(this), "")));

    function setUp() public {
        _proxy.tempStoreKeyValue("name", "Token name");
        _proxy.tempStoreKeyValue("symbol", "Token symbol");
        _proxy.deployToken();
    }

    function proxy() public view override returns (TransparentUpgradeableProxy) {
        return TransparentUpgradeableProxy(payable(address(_proxy)));
    }
}
