// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract MockRemoteStaticCall {
    mapping(bytes32 => bytes) public callResults;

    function call(bytes memory _data) external returns (bytes memory result) {
        result = callResults[keccak256(_data)];
        if (result.length == 0) {
            revert("No result set");
        }
        return result;
    }
    
    function setCallResult(bytes memory _data, bytes memory result) external {
        callResults[keccak256(_data)] = result;
    }
}

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
