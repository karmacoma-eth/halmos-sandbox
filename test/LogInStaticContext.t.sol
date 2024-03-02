contract Foo {
    event Log(uint256 x);

    function may_log(uint256 x) public returns (uint256) {
        if (x == 42) {
            emit Log(x);
        }
    }

    function test_log_staticcall(uint256 x) public returns (bool success) {
        (success,) = address(this).staticcall(abi.encodeWithSignature("may_log(uint256)", x));
        assert(success);
    }
}
