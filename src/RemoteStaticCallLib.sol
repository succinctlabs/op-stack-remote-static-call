// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

library RemoteStaticCall {
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
