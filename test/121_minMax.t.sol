// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

contract Game {
    function submit(uint256 x) public pure returns (uint256 score) {
        uint256 a = x % 97;
        uint256 b = x % 89;
        return a * b;
    }
}

contract Test121 is Test, SymTest {
    Game game;

    function setUp() public {
        game = new Game();
    }

    function check_minMax(uint256 x) external view {
        uint256 score = game.submit(x);
        assertLe(score, 42);
    }

    function test_minMax_verify() external view {
        // score = 128
        // uint256 x = 0x81dce8a00000000000000000000000000000000000000000000000000000000;

        // score = 8448, which is the theoretical maximum (97 * 88)
        uint256 x = 0x991badb6420e88c2dd40b0f4feaa5627b0006d5eb5f6cb80037ea97d03679e15;
        console2.log("x", x);
        console2.log("score", game.submit(x));
    }
}
