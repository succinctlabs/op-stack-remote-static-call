// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Mirror.sol";
import "./MockRemoteStaticCall.sol";

contract CounterTest is Test {
    NounsMirror public mirror;
    MockRemoteStaticCall public remote;

    function setUp() public {
        mirror = new NounsMirror();
        remote = new MockRemoteStaticCall();
        vm.etch(address(0x13), address(remote).code);
        remote = MockRemoteStaticCall(address(0x13));
    }

    function testVoting() public {
        remote.setCallResult(
            abi.encode(
                mirror.nouns(),
                abi.encodeWithSelector(
                    IERC721.balanceOf.selector,
                    address(this)
                )
            ),
            abi.encode(1)
        );
        assertEq(mirror.balanceOf(address(this)), 1);
    }
}
