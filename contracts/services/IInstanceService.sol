// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponentOwnerService.sol";
import "./IInstanceOperatorService.sol";
import "./IOracleService.sol";
import "./IProductService.sol";

interface IInstanceService {

    // owner
    function getOwner() external view returns(address owner);
    
    // registry
    function getComponentOwnerService() external view returns(IComponentOwnerService service);
    function getInstanceOperatorService() external view returns(IInstanceOperatorService service);
    function getOracleService() external view returns(IOracleService service);
    function getProductService() external view returns(IProductService service);

    // access
    function productOwnerRole() external view returns(bytes32 role);
    function oracleProviderRole() external view returns(bytes32 role);
    function riskpoolKeeperRole() external view returns(bytes32 role);
    function hasRole(bytes32 role, address principal) external view returns (bool hasRole);    

    // component
    function products() external view returns(uint256 products);
    function oracles() external view returns(uint256 oracles);
    function riskPools() external view returns(uint256 riskPools);
    function getComponent(uint256 id) external view returns(IComponent component);

    // service staking
    function getStakingRequirements(uint256 id) external view returns(bytes memory data);
    function getStakedAssets(uint256 id) external view returns(bytes memory data);
}
