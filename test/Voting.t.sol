// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Voting.sol";
import "../src/MockRemoteStaticCall.sol";

contract CounterTest is Test {
    L2Voting public voting;
    MockRemoteStaticCall public remote;

    function setUp() public {
        voting = new L2Voting();
        remote = new MockRemoteStaticCall();
        vm.etch(address(0x13), address(remote).code);
        remote = MockRemoteStaticCall(address(0x13));
    }

    function testVoting() public {
        remote.setCallResult(
            abi.encode(
                voting.nouns(),
                abi.encodeWithSelector(
                    IERC721.balanceOf.selector,
                    address(this)
                )
            ),
            abi.encode(1)
        );
        assertEq(voting.getTally(bytes32("1234")), 0);
        voting.vote(bytes32("1234"));
        assertEq(voting.getTally(bytes32("1234")), 1);
    }
}
