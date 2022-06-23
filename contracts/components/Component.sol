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
    ComponentStatus private _componentStatus;

    bytes32 private _requiredRole;

    IRegistry private _registry;
    IAccess private _access;
    IComponentOwnerService private _componentOwnerService;

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
        _componentStatus = ComponentStatus.Created;
        _requiredRole = _getRequiredRole();

        emit LogComponentCreated(
            _componentName, 
            _componentType, 
            address(this), 
            address(_registry));
    }

    function proposalCallback() 
        public 
        override
        onlyComponent
    {        
        emit LogComponentProposed(
            address(this),
            _componentId);
        _afterPropose();
    }

    function approvalCallback() 
        public 
        override
        onlyComponent
    {
        emit LogComponentApproved(_componentId);
        _afterApprove();
    }

    function declineCallback()
        public 
        override
        onlyComponent
    {
        emit LogComponentDeclined(_componentId);
        _afterDecline();
    }

    function suspendCallback()
        public 
        override
        onlyComponent
    {
        emit LogComponentSuspended(_componentId);
        _afterSuspend();
    }

    function resumeCallback()
        public 
        override
        onlyComponent
    {
        emit LogComponentResumed(_componentId);
        _afterResume();
    }

    function setId(uint256 id) external onlyComponent { _componentId = id; }
    function setStatus(ComponentStatus status) external onlyComponent { _componentStatus = status; }

    function getName() public view returns(bytes32) { return _componentName; }
    function getId() public view returns(uint256) { return _componentId; }
    function getType() public view returns(ComponentType) { return _componentType; }
    function getStatus() public view returns(ComponentStatus) { return _componentStatus; }
    function getOwner() external view returns(address) { return owner(); }

    function isProduct() public view returns(bool) { return _componentType == ComponentType.Product; }
    function isOracle() public view returns(bool) { return _componentType == ComponentType.Oracle; }
    function isRiskpool() public view returns(bool) { return _componentType == ComponentType.Riskpool; }

    function getRequiredRole() public view override returns(bytes32) { return _requiredRole; }

    function _afterPropose() internal virtual {}
    function _afterApprove() internal virtual {}
    function _afterDecline() internal virtual {}
    function _afterSuspend() internal virtual {}
    function _afterResume() internal virtual {}

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
