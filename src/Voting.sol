// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}

library IRemoteStaticCall {
    address public constant addr = address(0x13);

    function call(
        address to,
        bytes memory calldata_
    ) internal view returns (bytes memory) {
        (bool ok, bytes memory result) = addr.staticcall(
            abi.encode(to, calldata_)
        );
        if (!ok) {
            revert("Remote call failed");
        }
        return result;
    }

    function call(bytes memory _data) internal view returns (bytes memory) {
        (bool ok, bytes memory result) = addr.staticcall(_data);
        if (!ok) {
            revert("Remote call failed");
        }
        return result;
    }
}

contract L2Voting {
    address public nouns = address(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

    mapping(bytes32 => bool) voted;
    mapping(bytes23 => uint256) public proposalIdToTally;

    constructor() {}

    function vote(bytes32 _proposalId) external payable {
        if (voted[keccak256(abi.encodePacked(_proposalId, msg.sender))]) {
            revert("Cannot vote twice for same proposal");
        }

        bytes memory result = IRemoteStaticCall.call(
            abi.encode(
                nouns,
                abi.encodeWithSelector(IERC721.balanceOf.selector, msg.sender)
            )
        );
        uint256 balance = abi.decode(result, (uint256));
        proposalIdToTally[bytes23(_proposalId)] += balance;
    }

    // An example of how to directly call the precompile without using the library
    function voteWithoutLibrary(bytes32 _proposalId) external payable {
        if (voted[keccak256(abi.encodePacked(_proposalId, msg.sender))]) {
            revert("Cannot vote twice for same proposal");
        }

        (bool ok, bytes memory result) = address(0x13).staticcall(
            abi.encode(
                nouns,
                abi.encodeWithSelector(IERC721.balanceOf.selector, msg.sender)
            )
        );
        if (!ok) {
            revert("Remote call failed");
        }
        uint256 balance = abi.decode(result, (uint256));
        proposalIdToTally[bytes23(_proposalId)] += balance;
    }

    function getTally(bytes32 _proposalId) external view returns (uint256) {
        return proposalIdToTally[bytes23(_proposalId)];
    }
}
