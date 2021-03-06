// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponent.sol";
import "../modules/IAccess.sol";
import "../modules/IComponentEvents.sol";
import "../modules/IRegistry.sol";
import "../services/IComponentOwnerService.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/GUIDELINES.md#style-guidelines
abstract contract Component is 
    IComponent,
    IComponentEvents,
    Ownable 
{
    bytes32 private _componentName;
    uint256 private _componentId;
    ComponentType private _componentType;
    ComponentState private _componentState;

    bytes32 private _requiredRole;

    IRegistry private _registry;
    IAccess private _access;
    IComponentOwnerService private _componentOwnerService;

    event LogComponentCreated (
        bytes32 componentName,
        ComponentType componentType,
        address componentAddress,
        address registryAddress);

    modifier onlyInstanceOperatorService() {
        require(
             _msgSender() == _getContractAddress("InstanceOperatorService"),
            "ERROR:CMP-001:NOT_INSTANCE_OPERATOR_SERVICE");
        _;
    }

    modifier onlyComponent() {
        require(
             _msgSender() == _getContractAddress("Component"),
            "ERROR:CMP-002:NOT_COMPONENT");
        _;
    }

    modifier onlyComponentOwnerService() {
        require(
             _msgSender() == address(_componentOwnerService),
            "ERROR:CMP-002:NOT_COMPONENT_OWNER_SERVICE");
        _;
    }

    constructor(
        bytes32 name,
        ComponentType componentType,
        address registry
    )
        Ownable()
    {
        require(registry != address(0), "ERROR:CMP-003:REGISTRY_ADDRESS_ZERO");

        _registry = IRegistry(registry);
        _access = _getAccess();
        _componentOwnerService = _getComponentOwnerService();

        _componentName = name;
        _componentType = componentType;
        _componentState = ComponentState.Created;
        _requiredRole = _getRequiredRole();

        emit LogComponentCreated(
            _componentName, 
            _componentType, 
            address(this), 
            address(_registry));
    }

    function setId(uint256 id) external override onlyComponent { _componentId = id; }
    function setState(ComponentState state) external override onlyComponent { _componentState = state; }

    function getName() public override view returns(bytes32) { return _componentName; }
    function getId() public override view returns(uint256) { return _componentId; }
    function getType() public override view returns(ComponentType) { return _componentType; }
    function getState() public override view returns(ComponentState) { return _componentState; }
    function getOwner() public override view returns(address) { return owner(); }

    function isProduct() public override view returns(bool) { return _componentType == ComponentType.Product; }
    function isOracle() public override view returns(bool) { return _componentType == ComponentType.Oracle; }
    function isRiskpool() public override view returns(bool) { return _componentType == ComponentType.Riskpool; }

    function getRequiredRole() public override view returns(bytes32) { return _requiredRole; }

    function proposalCallback() public override onlyComponent { _afterPropose(); }
    function approvalCallback() public override onlyComponent { _afterApprove(); }
    function declineCallback() public override onlyComponent { _afterDecline(); }
    function suspendCallback() public override onlyComponent { _afterSuspend(); }
    function resumeCallback() public override onlyComponent { _afterResume(); }
    function pauseCallback() public override onlyComponent { _afterPause(); }
    function unpauseCallback() public override onlyComponent { _afterUnpause(); }

    // these functions are intended to be overwritten to implement
    // component specific notification handling
    function _afterPropose() internal virtual {}
    function _afterApprove() internal virtual {}
    function _afterDecline() internal virtual {}
    function _afterSuspend() internal virtual {}
    function _afterResume() internal virtual {}
    function _afterPause() internal virtual {}
    function _afterUnpause() internal virtual {}

    function _getRequiredRole() private returns (bytes32) {
        if (isProduct()) { return _access.productOwnerRole(); }
        if (isOracle()) { return _access.oracleProviderRole(); }
        if (isRiskpool()) { return _access.riskpoolKeeperRole(); }
    }

    function _getAccess() internal returns (IAccess) {
        return IAccess(_getContractAddress("Access"));        
    }

    function _getComponentOwnerService() internal returns (IComponentOwnerService) {
        return IComponentOwnerService(_getContractAddress("ComponentOwnerService"));        
    }

    function _getContractAddress(bytes32 contractName) internal returns (address) { 
        return _registry.getContract(contractName);
    }

}
