// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract UnRevertable {
    function noRevert(uint256) external payable {}
    receive() external payable {}
    fallback() external payable {}
}

contract TestUnRevertable is SymTest {
    UnRevertable unRevertable;

    function setUp() public {
        unRevertable = new UnRevertable();
    }

    function check_unrevertable() external {
        uint256 value = svm.createUint(256, "value");
        bytes memory data = svm.createBytes(16, "data");

        (bool succ, ) = address(unRevertable).call{value: value}(data);
        assert(succ);
    }
}
