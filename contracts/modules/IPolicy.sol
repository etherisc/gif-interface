// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPolicy {
    // Events
    event LogNewMetadata(
        uint256 productId,
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

    event LogPartialPayout(
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
        PolicyFlowState state;
        uint256 createdAt;
        uint256 updatedAt;
    }

    struct Application {
        uint256 productId;
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

    function createPolicyFlow(uint256 _productId, bytes32 _processId) external;

    function setPolicyFlowState(
        bytes32 _processId,
        IPolicy.PolicyFlowState _state
    ) external;

    function createApplication(bytes32 _processId, bytes calldata _data) external;

    function setApplicationState(
        bytes32 _processId,
        IPolicy.ApplicationState _state
    ) external;

    function createPolicy(bytes32 _processId) external;

    function setPolicyState(bytes32 _processId, IPolicy.PolicyState _state)
        external;

    function createClaim(bytes32 _processId, bytes calldata _data)
        external
        returns (uint256 _claimId);

    function setClaimState(
        bytes32 _processId,
        uint256 _claimId,
        IPolicy.ClaimState _state
    ) external;

    function createPayout(
        bytes32 _processId,
        uint256 _claimId,
        bytes calldata _data
    ) external returns (uint256 _payoutId);

    function payOut(
        bytes32 _processId,
        uint256 _payoutId,
        bool _complete,
        bytes calldata _data
    ) external;

    function setPayoutState(
        bytes32 _processId,
        uint256 _payoutId,
        IPolicy.PayoutState _state
    ) external;

    function getMetadata(bytes32 _processId)
        external
        view
        returns (IPolicy.Metadata memory _metadata);

    function getApplication(bytes32 _processId)
        external
        view
        returns (IPolicy.Application memory _application);

    function getPolicy(bytes32 _processId)
        external
        view
        returns (IPolicy.Policy memory _policy);

    function getClaim(bytes32 _processId, uint256 _claimId)
        external
        view
        returns (IPolicy.Claim memory _claim);

    function getPayout(bytes32 _processId, uint256 _payoutId)
        external
        view
        returns (IPolicy.Payout memory _payout);

    function getProcessIdCount() external view returns (uint256 _count);
}
