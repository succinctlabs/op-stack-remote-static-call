pragma solidity ^0.8.13;

contract MockRemoteStaticCall {
    mapping(bytes32 => bytes) public callResults;

    fallback() external {
        bytes memory result = callResults[keccak256(msg.data)];
        if (result.length == 0) {
            revert("No result set");
        }
        // We have to use assembly to return the result since `fallback` cannot return
        assembly {
            return(add(result, 32), mload(result))
        }
    }

    function call(
        bytes memory _data
    ) external view returns (bytes memory result) {}

    function setCallResult(bytes memory _data, bytes memory result) external {
        callResults[keccak256(_data)] = result;
    }
}
