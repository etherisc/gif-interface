// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

enum ComponentType {
    Oracle,
    Product,
    Riskpool
}

enum ComponentState {
    Created,
    Proposed,
    Declined,
    Active,
    Paused,
    Suspended
}

interface IComponent {

    function setId(uint256 id) external;
    function setState(ComponentState state) external;

    function getName() external view returns(bytes32);
    function getId() external view returns(uint256);
    function getType() external view returns(ComponentType);
    function getState() external view returns(ComponentState);
    function getOwner() external view returns(address);

    function getRequiredRole() external view returns(bytes32 role);

    function isProduct() external view returns(bool);
    function isOracle() external view returns(bool);
    function isRiskpool() external view returns(bool);

    function proposalCallback() external;
    function approvalCallback() external; 
    function declineCallback() external;
    function suspendCallback() external;
    function resumeCallback() external;
    function pauseCallback() external;
    function unpauseCallback() external;
}