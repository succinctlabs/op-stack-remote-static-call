// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}

interface IRemoteStaticCall {
    function call(bytes calldata _data) external returns (bytes memory result);
}

contract L2Voting {
    address public nouns = address(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

    mapping(bytes32 => bool) voted;
    mapping(bytes23 => uint256) public proposalIdToTally;

    constructor() {
    }

    function vote(bytes32 _proposalId) external payable {
        if (voted[keccak256(abi.encodePacked(_proposalId, msg.sender))]) {
            revert("Cannot vote twice for same proposal");
        }

        bytes memory result = IRemoteStaticCall(address(0x19)).call(
            abi.encode(
                nouns,
                abi.encodeWithSelector(IERC721.balanceOf.selector, msg.sender)
            )
        );
        uint256 balance = abi.decode(result, (uint256));
        proposalIdToTally[bytes23(_proposalId)] += balance;
    }

    function getTally(bytes32 _proposalId) external view returns (uint256) {
        return proposalIdToTally[bytes23(_proposalId)];
    }
}
