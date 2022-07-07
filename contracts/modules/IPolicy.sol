// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPolicy {
    // Events
    event LogNewMetadata(
        bytes32 processId,
        PolicyFlowState state
    );

    event LogMetadataStateChanged(
        bytes32 processId, 
        PolicyFlowState state
    );

    event LogNewApplication(
        uint256 productId, 
        bytes32 processId, 
        uint256 premiumAmount, 
        uint256 sumInsuredAmount
    );

    event LogApplicationStateChanged(
        bytes32 processId, 
        ApplicationState state
    );

    event LogNewPolicy(bytes32 processId);

    event LogPolicyStateChanged(
        bytes32 processId, 
        PolicyState state
    );

    event LogNewClaim(
        bytes32 processId, 
        uint256 claimId, 
        ClaimState state
    );

    event LogClaimStateChanged(
        bytes32 processId,
        uint256 claimId,
        ClaimState state
    );

    event LogNewPayout(
        bytes32 processId,
        uint256 claimId,
        uint256 payoutId,
        PayoutState state
    );

    event LogPayoutStateChanged(
        bytes32 processId,
        uint256 payoutId,
        PayoutState state
    );

    event LogPayoutCompleted(
        bytes32 processId,
        uint256 payoutId,
        PayoutState state
    );

    event LogPayoutProcessed(
        bytes32 processId, 
        uint256 payoutId, 
        PayoutState state
    );

    // States
    enum PolicyFlowState {Started, Paused, Finished}

    enum ApplicationState {Applied, Revoked, Underwritten, Declined}

    enum PolicyState {Active, Expired}

    enum ClaimState {Applied, Confirmed, Declined}

    enum PayoutState {Expected, PaidOut}

    // Objects
    struct Metadata {
        address owner;
        uint256 productId;
        PolicyFlowState state;
        bytes data;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Application {
        ApplicationState state;
        uint256 premiumAmount;
        uint256 sumInsuredAmount;
        bytes data; 
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Policy {
        PolicyState state;
        uint256 claimsCount;
        uint256 payoutsCount;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Claim {
        ClaimState state;
        bytes data;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Payout {
        uint256 claimId;
        PayoutState state;
        uint256 payoutAmount;
        bytes data;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function createPolicyFlow(
        bytes32 processId, 
        bytes calldata data
    ) external;

    function setPolicyFlowState(
        bytes32 processId,
        IPolicy.PolicyFlowState state
    ) external;

    function createApplication(
        uint256 productId, 
        bytes32 processId, 
        uint256 premiumAmount,
        uint256 sumInsuredAmount,
        bytes calldata data
    ) external;

    function setApplicationState(
        bytes32 processId,
        IPolicy.ApplicationState state
    ) external;

    function createPolicy(bytes32 processId) external;

    function setPolicyState(bytes32 processId, IPolicy.PolicyState state)
        external;

    function createClaim(bytes32 processId, bytes calldata data)
        external
        returns (uint256 claimId);

    function setClaimState(
        bytes32 processId,
        uint256 claimId,
        IPolicy.ClaimState state
    ) external;

    function createPayout(
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

    function setPayoutState(
        bytes32 processId,
        uint256 payoutId,
        IPolicy.PayoutState state
    ) external;

    function getMetadata(bytes32 processId)
        external
        view
        returns (IPolicy.Metadata memory metadata);

    function getApplication(bytes32 processId)
        external
        view
        returns (IPolicy.Application memory application);

    function getPolicy(bytes32 processId)
        external
        view
        returns (IPolicy.Policy memory policy);

    function getClaim(bytes32 processId, uint256 claimId)
        external
        view
        returns (IPolicy.Claim memory claim);

    function getPayout(bytes32 processId, uint256 payoutId)
        external
        view
        returns (IPolicy.Payout memory payout);

    function getProcessIdCount() external view returns (uint256 count);
}
