// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IProductService {

    function newApplication(
        address owner,
        bytes32 processId,
        uint256 premiumAmount,
        uint256 sumInsuredAmount,
        bytes calldata metaData, 
        bytes calldata applicationData 
    ) external;

    function decline(bytes32 processId) external;
    function underwrite(bytes32 processId) external;
    function expire(bytes32 processId) external;

    function newClaim(
        bytes32 processId, 
        bytes calldata data
    ) external returns (uint256 claimId);

    function declineClaim(bytes32 processId, uint256 claimId) external;

    function confirmClaim(
        bytes32 processId, 
        uint256 claimId, 
        uint256 payoutAmount, 
        bytes calldata data
    ) external returns (uint256 payoutId);

    function processPayout(
        bytes32 processId, 
        uint256 payoutId, 
        bool isComplete, 
        bytes calldata data
    ) external;

    function request(
        bytes32 processId,
        bytes calldata data,
        string calldata callbackMethodName,
        address callbackContractAddress,
        uint256 responsibleOracleId
    ) external returns (uint256 requestId);
}
