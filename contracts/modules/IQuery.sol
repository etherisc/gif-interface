// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IQuery {

    struct OracleRequest {
        bytes32 processId;
        uint256 responsibleOracleId;
        address callbackContractAddress;
        string callbackMethodName;
        bytes data;
        uint256 createdAt;
    }

    event LogOracleRequested(
        bytes32 processId,
        uint256 requestId,
        uint256 responsibleOracleId
    );

    event LogOracleResponded(
        bytes32 processId,
        uint256 requestId,
        address responder,
        bool success
    );

    event LogOracleCanceled(
        uint256 requestId
    );

    function request(
        bytes32 processId,
        bytes calldata input,
        string calldata callbackMethodName,
        address callbackContractAddress,
        uint256 responsibleOracleId
    ) external returns (uint256 requestId);

    function respond(
        uint256 requestId,
        address responder,
        bytes calldata data
    ) external;

    function cancel(uint256 requestId) external;

}
