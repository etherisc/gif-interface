// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IInstanceOperatorService {
    function assignController(address _storage, address _controller) external;
    function assignStorage(address _controller, address _storage) external;

    // License
    function approveProduct(uint256 _productId) external;
    function disapproveProduct(uint256 _productId) external;
    function pauseProduct(uint256 _productId) external;

    // Access
    function createRole(bytes32 _role) external;
    function addRoleToAccount(address _address, bytes32 _role) external;
    function cleanRolesForAccount(address _address) external;

    // Registry
    function registerInRelease(
        bytes32 _release,
        bytes32 _contractName,
        address _contractAddress
    ) external;

    function register(bytes32 _contractName, address _contractAddress) external;
    function deregisterInRelease(bytes32 _release, bytes32 _contractName) external;
    function deregister(bytes32 _contractName) external;
    function prepareRelease(bytes32 _newRelease) external;

    // TODO functions to component based model
    function approveOracle(uint256 _oracleId) external;
    function disapproveOracle(uint256 _oracleId) external;

    function products() external view returns(uint256 products);
    function oracles() external view returns(uint256 oracles);
}