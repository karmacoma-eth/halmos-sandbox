// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

contract BurnsGas {
    event Log(string message, uint256 value);

    function burnGas() external {
        for (uint256 i = 0; i < 1000; i++) {
            emit Log("gas left", gasleft());
        }
    }
}

contract CallsThings {
    function lowLevelCall(address target, bytes memory data, uint256 gas)
        external
        returns (bool succ, bytes memory returndata)
    {
        (succ, returndata) = target.call{gas: gas}(data);
    }

    function directCall() external {
        BurnsGas burner = new BurnsGas();
        burner.burnGas{gas: 10000}();
    }
}

contract Test16 is Test {
    CallsThings caller = new CallsThings();

    function test_GasBurner_lowLevel() external {
        BurnsGas burner = new BurnsGas();

        (bool succ, bytes memory returndata) =
            caller.lowLevelCall(address(burner), abi.encodeWithSignature("burnGas()"), 10000);

        assertEq(succ, true);
        assertEq(returndata.length, 0);
    }

    /// @custom:halmos --loop=2
    function test_GasBurner_direct() external {
        caller.directCall();
    }
}
