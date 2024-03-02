// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Owned {
    address public owner;
    address private ownerCandidate;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyOwnerCandidate() {
        require(msg.sender == ownerCandidate);
        _;
    }

    function transferOwnership(address candidate) external onlyOwner {
        ownerCandidate = candidate;
    }

    function acceptOwnership() external onlyOwnerCandidate {
        owner = ownerCandidate;
    }
}

contract TestOwned is Owned {
    address private initialOwner;

    constructor() {
        initialOwner = msg.sender;
    }

    // echidna test/30_twoStepOwnershipTransferEchidna.t.sol --contract TestOwned
    // Call sequence:
    // 1.transferOwnership(0x20000) from: 0x0000000000000000000000000000000000030000 Time delay: 136393 seconds Block
    //   delay: 2512
    // 2.acceptOwnership() from: 0x0000000000000000000000000000000000020000 Time delay: 522178 seconds Block delay: 2431
    function echidna_invariant_owner_never_changes_this_is_bad_lol() public view returns (bool) {
        return owner == initialOwner;
    }
}
