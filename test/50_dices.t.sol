// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

/// https://twitter.com/cergyk1337/status/1732397105728061818
/// https://goerli.etherscan.io/address/0x7376ca187427af998b98101f23d094d961180fc5#code
contract Dices {
    uint256 public constant DICES_NUMBER = 40;
    uint256 public constant ARRAY_ENCODING_BYTES_SIZE = 32 + 32 + DICES_NUMBER * 32;

    address public winner;
    mapping(bytes32 => bool) used;

    constructor() {
        console2.log("Deploying Dices, n =", DICES_NUMBER);
        // Mark all of the winning dice combinations as used >:‑)
        uint256[] memory winningCombo = new uint256[](DICES_NUMBER);
        for (uint256 i; i < DICES_NUMBER; ++i) {
            if (i != 0) {
                winningCombo[i - 1] = 0;
            }
            winningCombo[i] = 1;

            bytes32 key = keccak256(abi.encode(winningCombo));
            used[key] = true;
        }
    }

    /**
     * Checks if the winning combination has been used
     */
    modifier checkCalldata() {
        // Hashing the numbers array directly in calldata for efficiency
        bytes32 hash = keccak256(msg.data[4:ARRAY_ENCODING_BYTES_SIZE + 4]);
        require(!used[hash], "Used");

        _;
    }

    /**
     * Claim a winning combination
     * @param dices the winning combination to attempt
     */
    function roll(uint256[] calldata dices) public checkCalldata {
        require(winner == address(0), "Already won");
        require(dices.length == DICES_NUMBER, "Too many dices");

        // The score of the player is the sum of the dices values
        uint256 score;
        for (uint256 i; i < DICES_NUMBER; ++i) {
            score += dices[i];
        }

        // If the score is exactly one, the player wins!
        require(score == 1, "Wrong sum");

        // Set winner, claim prize
        winner = msg.sender;
        (bool success,) = winner.call{value: address(this).balance}("");
        require(success);
    }

    receive() external payable {}
}

contract Test50 is Test {
    Dices dices;

    function setUp() public {
        dices = new Dices();
    }

    function test_dices() external {}
}
