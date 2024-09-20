// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";

import {SymTest} from "halmos-cheatcodes/SymTest.sol";

import {ERC20 as ERC20OpenZepBase} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20 as ERC20SoladyBase} from "solady/src/tokens/ERC20.sol";

contract ERC20OpenZep is ERC20OpenZepBase {
    address owner;

    constructor() ERC20OpenZepBase("ERC20OpenZep", "BEEP") {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "ERC20Solady: only owner can mint");
        _mint(to, amount);
    }
}

contract ERC20Solady is ERC20SoladyBase {
    address owner;

    constructor() ERC20SoladyBase() {
        owner = msg.sender;
    }

    function mint(address to, uint256 amount) public {
        require(msg.sender == owner, "ERC20Solady: only owner can mint");
        _mint(to, amount);
    }

    function name() public view virtual override returns (string memory) {
        return "ERC20Solady";
    }

    function symbol() public view virtual override returns (string memory) {
        return "BOOP";
    }
}

contract Test96 is Test, SymTest {
    ERC20OpenZep openZepToken;
    ERC20Solady soladyToken;

    function setUp() public {
        openZepToken = new ERC20OpenZep();
        soladyToken = new ERC20Solady();

        // mint some initial tokens
        uint256 mintAmount = svm.createUint256("mintAmount");
        address minter = svm.createAddress("minter");
        soladyToken.mint(minter, mintAmount);
        openZepToken.mint(minter, mintAmount);

        // transfer some to 2 other accounts
        address account1 = svm.createAddress("account1");
        address account2 = svm.createAddress("account2");
        uint256 transferAmount1 = svm.createUint256("transferAmount1");
        uint256 transferAmount2 = svm.createUint256("transferAmount2");

        vm.assume(transferAmount1 + transferAmount2 <= mintAmount);

        vm.startPrank(minter);
        soladyToken.transfer(account1, transferAmount1);
        openZepToken.transfer(account1, transferAmount1);

        soladyToken.transfer(account2, transferAmount2);
        openZepToken.transfer(account2, transferAmount2);
        vm.stopPrank();
    }

    // [PASS] test_compareBalances(address) (paths: 3, time: 63.50s (paths: 0.08s, models: 63.42s), bounds: [])
    //
    // different solvers have wildly different perf:
    //
    //   bitwuzla   ███                            00:00:05.126 exitcode=0    unsat
    //   boolector  ████████████████████████       00:00:42.329 exitcode=20   unsat
    //   cvc4       █                              00:00:00.737 exitcode=0    unsat
    //   cvc5       █                              00:00:00.527 exitcode=0    unsat
    //   stp        █                              00:00:00.013 exitcode=0    error
    //   yices-smt2 ██████████                     00:00:18.058 exitcode=0    unsat
    //   z3         ██████████████████████████████ 00:00:51.029 exitcode=1    unsat
    function test_compareBalances(address account) external view {
        assertEq(soladyToken.balanceOf(account), openZepToken.balanceOf(account));
    }
}
