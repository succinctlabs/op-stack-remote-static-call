// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Voting.sol";
import "../src/MockRemoteStaticCall.sol";


contract CounterTest is Test {
    L2Voting public voting;

    function setUp() public {
        voting = new L2Voting();
    }

    function testVoting() public {
        MockRemoteStaticCall remote = new MockRemoteStaticCall();
        remote.setCallResult(
            abi.encode(
                voting.nouns(),
                abi.encodeWithSelector(IERC721.balanceOf.selector, address(this))
            ),
            abi.encode(1)
        );
        vm.etch(0x19, remote);
        assertEq(voting.getTally(bytes32("1234")), 0);
        voting.vote(bytes32("1234"));
        assertEq(voting.getTally(bytes32("1234")), 1);
    }

}
