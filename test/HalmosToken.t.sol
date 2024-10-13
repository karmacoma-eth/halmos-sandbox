// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {SymTest} from "halmos-cheatcodes/SymTest.sol";
import {ERC20} from "solady/tokens/ERC20.sol";
import {Ownable} from "solady/auth/Ownable.sol";

contract HalmosToken is ERC20, Ownable {
    function name() public view override returns (string memory) {
        return "HalmosToken";
    }

    /// @dev Returns the symbol of the token.
    function symbol() public view override returns (string memory) {
        return "HT";
    }

    function initialize() public {
        _initializeOwner(msg.sender); // No _guardInitializeOwner()
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }
}

/// @custom:halmos --storage-layout=generic
contract HalmosTokenTest is SymTest, Test {
    HalmosToken token;
    address owner;

    function setUp() public {
        owner = svm.createAddress("owner");
        vm.startPrank(owner);

        uint256 initialSupply = svm.createUint256("initialSupply");
        vm.assume(initialSupply < 10); // This is to help make debugging easier but you can remove it.

        token = new HalmosToken();
        token.initialize();
        token.mint(owner, initialSupply);
    }

    function check_0xlgtm_transfer() public {
        // specify input conditions
        address sender = svm.createAddress("sender");
        address receiver = svm.createAddress("receiver");
        uint256 senderBalance = svm.createUint256("senderBalance");
        uint256 receiverBalance = svm.createUint256("receiverBalance");
        uint256 amount = svm.createUint256("amount");

        // Assumptions
        uint256 totalSupply = token.totalSupply();
        vm.assume(sender != address(0));
        vm.assume(receiver != address(0));
        // vm.assume(sender != owner);
        // vm.assume(receiver != owner);

        vm.assume(senderBalance + receiverBalance <= totalSupply);
        vm.assume(amount <= senderBalance);
        vm.assume(receiverBalance + amount <= totalSupply); // maybe redundant?
        vm.assume(sender != receiver);

        // Call target contract
        vm.startPrank(owner);
        token.transfer(sender, senderBalance);
        token.transfer(receiver, receiverBalance);
        vm.stopPrank();

        vm.prank(sender);
        token.transfer(receiver, amount);

        // check output state
        assertEq(token.balanceOf(sender), senderBalance - amount);
        assertEq(token.balanceOf(receiver), receiverBalance + amount);
    }
}
