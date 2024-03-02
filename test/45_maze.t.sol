// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {LibString} from "solmate/utils/LibString.sol";

contract Test45 is Test {
    enum Move {
        UP,
        DOWN,
        LEFT,
        RIGHT
    }

    bool constant DEBUG = false;
    uint256 constant SAMPLE_RATE = 24;
    uint256 currentSample = SAMPLE_RATE;

    function info(bytes[] memory maze, uint256 num, string memory s) public {
        if (DEBUG) {
            // if (currentSample != 0) {
            //     currentSample--;
            //     return;
            // }

            // currentSample = SAMPLE_RATE;

            string memory maze_str = string.concat(
                "        ",
                string(maze[0]),
                "        ",
                string(maze[1]),
                "        ",
                string(maze[2]),
                "        ",
                string(maze[3]),
                "        ",
                string(maze[4])
            );
            // "        ", string(maze[5]),
            // "        ", string(maze[6]),
            // "        ", string(maze[7]),
            // "        ", string(maze[8]),
            // "        ", string(maze[9])

            // clear screen
            string memory CLEAR_SCREEN = unicode"[2J";
            string memory message = string.concat(
                CLEAR_SCREEN, unicode"\n    ", LibString.toString(num), " moves // ", s, unicode"\n\n", maze_str
            );

            console2.log(message);
        }
    }

    function render_maze(bytes[] memory maze) public pure {
        unchecked {
            uint256 length = maze.length;
            for (uint256 i = 0; i < length; i++) {
                console2.log(string(maze[i]));
            }
        }
    }

    /// @custom:halmos --loop=12 --statistics
    function test_maze(uint8[] calldata moves) external {
        /// @dev hard maze, 18 moves, dead ends, multiple solutions
        // starting position:
        // uint256 x = 0;
        // uint256 y = 4;

        // bytes[] memory maze = new bytes[](10);
        // maze[0] = unicode"###########\n";
        // maze[1] = unicode"#   #     #\n";
        // maze[2] = unicode"# # # # # #\n";
        // maze[3] = unicode"### ### ###\n";
        // maze[4] = unicode"S #   #   E\n";
        // maze[5] = unicode"# # # ### #\n";
        // maze[6] = unicode"#   #     #\n";
        // maze[7] = unicode"##### # ###\n";
        // maze[8] = unicode"#     #   #\n";
        // maze[9] = unicode"###########\n";

        /// @dev medium maze, 16 moves
        // starting position:
        // uint256 x = 0;
        // uint256 y = 1;

        bytes[] memory maze = new bytes[](5);
        maze[0] = unicode"#########\n";
        maze[1] = unicode"S #   # E\n";
        maze[2] = unicode"# # # # #\n";
        maze[3] = unicode"#   #   #\n";
        maze[4] = unicode"#########\n";

        /// @dev easy maze, 12 moves
        // starting position:
        uint256 x = 0;
        uint256 y = 1;

        console2.log("moves.length =", moves.length);
        uint256 maze_width = maze[0].length;
        uint256 maze_height = maze.length;

        unchecked {
            for (uint256 i = 0; i < moves.length; i++) {
                // for foundry
                uint8 move = moves[i] % 4;
                uint256 n = i + 1;

                // update player position with current move
                if (move == uint8(Move.RIGHT)) {
                    if (x == maze_width) {
                        return info(maze, n, unicode"❌ x > maze_width");
                    }
                    x++;
                } else if (move == uint8(Move.DOWN)) {
                    if (y == maze_height) {
                        return info(maze, n, unicode"❌ y > maze_height");
                    }
                    y++;
                } else if (move == uint8(Move.LEFT)) {
                    if (x == 0) {
                        return info(maze, n, unicode"❌ x < 0");
                    }
                    x--;
                } else if (move == uint8(Move.UP)) {
                    if (y == 0) {
                        return info(maze, n, unicode"❌ y < 0");
                    }
                    y--;
                } else {
                    return info(maze, n, unicode"❌ invalid move");
                }

                if (maze[y][x] == "#") {
                    maze[y][x] = "X";
                    return info(maze, n, unicode"❌ hit wall");
                } else if (maze[y][x] == "E") {
                    // we did it 🙌
                    info(maze, n, unicode"🏁 reached the end!");
                    assert(false);
                } else {
                    maze[y][x] = ".";
                    info(maze, n, unicode"🐿️  searching");
                }
            }
        }
    }
}
