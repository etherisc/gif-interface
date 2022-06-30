// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IProductService {

    function newApplication(bytes32 processId, bytes calldata data) external;
    function underwrite(bytes32 processId) external;
    function decline(bytes32 processId) external;
    function newClaim(bytes32 processId, bytes calldata data) external returns (uint256 claimId);
    function confirmClaim(bytes32 processId, uint256 claimId, bytes calldata data) external returns (uint256 payoutId);
    function declineClaim(bytes32 processId, uint256 claimId) external;
    function expire(bytes32 processId) external;
    function payout(bytes32 processId, uint256 payoutId, bool complete, bytes calldata data) external;

    function request(
        bytes32 processId,
        bytes calldata data,
        string calldata callbackMethodName,
        address callbackContractAddress,
        uint256 responsibleOracleId
    ) external returns (uint256 requestId);
}
