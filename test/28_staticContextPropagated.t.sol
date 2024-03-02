// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Foo {
    event FooEvent();

    function logFoo() public returns (uint256) {
        emit FooEvent();
        return 42;
    }

    function view_func() public returns (bool succ) {
        (succ,) = address(this).call(abi.encodeWithSignature("logFoo()"));
    }

    function testStaticContext() public view {
        (bool outerSucc, bytes memory ret) = address(this).staticcall(abi.encodeWithSignature("view_func()"));
        assert(outerSucc);

        bool innerSucc = abi.decode(ret, (bool));
        assert(!innerSucc);
    }
}
