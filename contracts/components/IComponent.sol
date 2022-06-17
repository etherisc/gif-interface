// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IComponent {

    event LogComponentCreated (
        bytes32 componentName,
        uint16 componentType,
        address componentAddress,
        address registry
    );

    event LogComponentProposed(
        address componentAddress,
        uint256 id);

    event LogComponentApproved(uint256 id);
    event LogComponentDeclined(uint256 id);

    function proposalCallback() external; // only component module, set to proposed
    function approvalCallback(address [] calldata tokens, uint256 [] calldata amounts) external; // only component module, set to active, staking reqs
    function declineCallback() external; // only component module, set to declined

    function setId(uint256 id) external; // only component module
    function setState(uint16 state) external; // only component module

    function getName() external view returns(bytes32);
    function getId() external view returns(uint256);
    function getType() external view returns(uint16);
    function getState() external view returns(uint16);
    function getOwner() external view returns(address);

    function getRequiredRole() external view returns(bytes32 role);
    function getRequiredAssets() external view returns(address [] memory tokens, uint256 [] memory amounts); // returns staked assets required for approval

    function isProduct() external view returns(bool);
    function isOracle() external view returns(bool);
    function isRiskpool() external view returns(bool);
}