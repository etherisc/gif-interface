// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IQuery {

    struct OracleRequest {
        bytes data;
        bytes32 bpKey;
        string callbackMethodName;
        address callbackContractAddress;
        uint256 responsibleOracleId;
        uint256 createdAt;
    }

    event LogOracleRequested(
        bytes32 bpKey,
        uint256 requestId,
        uint256 responsibleOracleId
    );

    event LogOracleResponded(
        bytes32 bpKey,
        uint256 requestId,
        address responder,
        bool success
    );

    function request(
        bytes32 _bpKey,
        bytes calldata _input,
        string calldata _callbackMethodName,
        address _callbackContractAddress,
        uint256 _responsibleOracleId
    ) external returns (uint256 _requestId);

    function respond(
        uint256 _requestId,
        address _responder,
        bytes calldata _data
    ) external;

}
