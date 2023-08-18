pragma solidity ^0.8.13;

contract MockRemoteStaticCall {
    mapping(bytes32 => bytes) public callResults;

    function call(bytes memory _data) external view returns (bytes memory result) {
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