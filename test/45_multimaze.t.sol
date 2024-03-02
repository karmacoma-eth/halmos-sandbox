// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {LibString} from "solmate/utils/LibString.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";

enum Move {
    UP,
    DOWN,
    LEFT,
    RIGHT
}

enum Result {
    VALID,
    INVALID,
    END
}

abstract contract Maze {
    event Position(uint256 indexed x, uint256 indexed y);

    uint256 public x;
    uint256 public y;

    bytes[] public state;

    constructor(uint256 startX, uint256 startY) {
        x = startX;
        y = startY;

        /// @dev children are responsible for initializing state
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function updateState() internal returns (Result) {
        require(state[y][x] != "#", "Blocked position");

        if (state[y][x] == "E") {
            return Result.END;
        } else {
            state[y][x] = ".";
            return Result.VALID;
        }
    }

    /*//////////////////////////////////////////////////////////////
                             VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function viewState() public view returns (bytes[] memory) {
        return state;
    }

    function endReached() public view returns (bool) {
        return state[y][x] == "E";
    }

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function up() external returns (Result) {
        require(y > 0, "Move UP not possible");
        y -= 1;

        return updateState();
    }

    function down() external returns (Result) {
        require(y < state.length - 1, "Move DOWN not possible");
        y += 1;

        return updateState();
    }

    function left() external returns (Result) {
        require(x > 0, "Move LEFT not possible");
        x -= 1;

        return updateState();
    }

    function right() external returns (Result) {
        require(x < state[y].length - 1, "Move RIGHT not possible");
        x += 1;

        return updateState();
    }
}

/// 4 moves
contract SuperEasyMaze is Maze {
    constructor() Maze(0, 1) {
        state.push("###");
        state.push("S #");
        state.push("# #");
        state.push("# E");
        state.push("###");
    }
}

/// 8 moves
contract EasyMaze is Maze {
    constructor() Maze(0, 1) {
        state.push("#####");
        state.push("S # E");
        state.push("# # #");
        state.push("#   #");
        state.push("#####");
    }
}

/// 10 moves, multiple solutions
contract MediumMaze is Maze {
    constructor() Maze(0, 3) {
        state.push("#######");
        state.push("#     #");
        state.push("# # # #");
        state.push("S   # E");
        state.push("#######");
    }
}

/// 18 moves, dead ends, multiple solutions
contract HardMaze is Maze {
    constructor() Maze(0, 4) {
        state.push("###########");
        state.push("#   #     #");
        state.push("# # # # # #");
        state.push("### ### ###");
        state.push("S #   #   E");
        state.push("# # # ### #");
        state.push("#   #     #");
        state.push("##### # ###");
        state.push("#     #   #");
        state.push("###########");
    }
}

/*//////////////////////////////////////////////////////////////
                            HALMOS TESTS
//////////////////////////////////////////////////////////////*/

contract HalmosTest is SymTest, Test {
    bool constant DEBUG = false;

    function info(bytes[] memory mazeState, uint256 num, string memory s) public {
        if (DEBUG) {
            string memory mazeString = rendered_maze(mazeState);

            // clear screen
            string memory CLEAR_SCREEN = unicode"[2J";
            string memory message = string.concat(
                CLEAR_SCREEN, unicode"\n    ", LibString.toString(num), " moves // ", s, unicode"\n\n", mazeString
            );

            console2.log(message);
        }
    }

    function rendered_maze(bytes[] memory mazeState) public pure returns (string memory mazeString) {
        unchecked {
            uint256 length = mazeState.length;
            for (uint256 i = 0; i < length; i++) {
                mazeString = string.concat(mazeString, "        ", string(mazeState[i]), "\n");
            }
        }
    }

    function performSymbolicMove(Maze maze) public returns (uint256 move) {
        move = svm.createUint256("move");

        if (move == 0x11111111 << 192) {
            maze.up();
        } else if (move == 0xffffffff << 224) {
            maze.left();
        } else if (move == 0xdddddddd << 128) {
            maze.down();
        } else if (move == 0xffffffff) {
            maze.right();
        }
    }
}

contract SuperEasyMazeHalmosTest is HalmosTest {
    Maze maze;

    function setUp() public {
        maze = new SuperEasyMaze();
    }

    /// @custom:halmos --loop=12 --statistics
    function check_SuperEasyMaze_endReached() external {
        for (uint256 i = 0; i < 4; i++) {
            performSymbolicMove(maze);
            assert(!maze.endReached());
        }
    }
}

contract EasyMazeHalmosTest is HalmosTest {
    Maze maze;

    function setUp() public {
        maze = new EasyMaze();
    }

    /// @custom:halmos --loop=12 --statistics
    function check_EasyMaze_endReached() external {
        for (uint256 i = 0; i < 8; i++) {
            performSymbolicMove(maze);
            assert(!maze.endReached());
        }
    }
}

/*//////////////////////////////////////////////////////////////
                            FOUNDRY TESTS
//////////////////////////////////////////////////////////////*/

contract SuperEasyMazeFoundryTest is Test {
    Maze maze;

    function setUp() public {
        maze = new SuperEasyMaze();
    }

    function invariant_SuperEasyMaze_endReached() public view {
        assert(!maze.endReached());
    }
}

contract EasyMazeFoundryTest is Test {
    Maze maze;

    function setUp() public {
        maze = new EasyMaze();
    }

    function invariant_EasyMaze_endReached() public view {
        assert(!maze.endReached());
    }
}

contract MediumMazeFoundryTest is Test {
    Maze maze;

    function setUp() public {
        maze = new MediumMaze();
    }

    function invariant_MediumMaze_endReached() public view {
        assert(!maze.endReached());
    }
}
