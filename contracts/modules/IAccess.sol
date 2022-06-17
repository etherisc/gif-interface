// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IAccess {
    function productOwnerRole() external view returns(bytes32 role);
    function oracleProviderRole() external view returns(bytes32 role);
    function riskpoolKeeperRole() external view returns(bytes32 role);
    function hasRole(bytes32 role, address principal) external view returns(bool);

    function grantRole(bytes32 role, address principal) external;
    function revokeRole(bytes32 role, address principal) external;
    function renounceRole(bytes32 role, address principal) external;

    function enforceProductOwnerRole(address account) external view;
    function enforceOracleProviderRole(address account) external view;
    function enforceRiskpoolKeeperRole(address account) external view;
    function enforceRole(bytes32 role, address account) external view;
    
    function addRole(bytes32 role) external;
    function invalidateRole(bytes32 role) external;
}
