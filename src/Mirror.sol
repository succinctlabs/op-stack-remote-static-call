// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RemoteStaticCall} from "./RemoteStaticCallLib.sol";

interface IERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);
}

contract NounsMirror {
    address public nouns = address(0x1dfe7Ca09e99d10835Bf73044a23B73Fc20623DF);

    function balanceOf(address owner) external view returns (uint256 balance) {
        bytes memory result = RemoteStaticCall.call(
            abi.encode(
                nouns,
                abi.encodeWithSelector(IERC721.balanceOf.selector, owner)
            )
        );
        return abi.decode(result, (uint256));
    }

    function ownerOf(uint256 tokenId) external view returns (address owner) {
        bytes memory result = RemoteStaticCall.call(
            abi.encode(
                nouns,
                abi.encodeWithSelector(IERC721.ownerOf.selector, tokenId)
            )
        );
        return abi.decode(result, (address));
    }
}
