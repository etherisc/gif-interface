// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInstanceOperatorService {

    // registry
    function prepareRelease(bytes32 newRelease) external;
    function register(bytes32 contractName, address contractAddress) external;
    function deregister(bytes32 contractName) external;
    function registerInRelease(bytes32 release, bytes32 contractName, address contractAddress) external;
    function deregisterInRelease(bytes32 release, bytes32 contractName) external;

    // access
    function createRole(bytes32 role) external;
    function grantRole(bytes32 role, address principal) external;
    function revokeRole(bytes32 role, address principal) external;

    // component
    function approve(uint256 id, address [] calldata tokens, uint256 [] calldata amounts) external;
    function decline(uint256 id) external;
    function suspend(uint256 id) external;
    function resume(uint256 id) external;

    // TODO 3 rename to approve, decline,then add suspend, resume
    function approveProduct(uint256 _productId) external;
    function disapproveProduct(uint256 _productId) external;
    function pauseProduct(uint256 _productId) external;
    function approveOracle(uint256 _oracleId) external;
    function disapproveOracle(uint256 _oracleId) external;
}
