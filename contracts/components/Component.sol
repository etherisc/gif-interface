// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponent.sol";
import "../services/IComponentOwnerService.sol";
import "../modules/IAccess.sol";
import "../modules/IRegistry.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/GUIDELINES.md#style-guidelines
abstract contract Component is 
    IComponent,
    Ownable 
{
    uint16 public constant PRODUCT_TYPE = 1;
    uint16 public constant ORACLE_TYPE = 2;
    uint16 public constant RISKPOOL_TYPE = 3;

    bytes32 private _componentName;
    uint256 private _componentId;
    uint16 private _componentType;
    uint16 private _componentState;

    bytes32 private _requiredRole;
    address [] private _requiredTokens;
    uint256 [] private _requiredAmounts;
    bool private _requiredStakingDefined;

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
        uint16 componentType,
        address registry
    )
        Ownable()
    {
        require(registry != address(0), "ERROR:CMP-003:REGISTRY_ADDRESS_ZERO");
        require(componentType <= 3, "ERROR:CMP-002:TYPE_INVALID");

        _registry = IRegistry(registry);
        _access = _getAccess();
        _componentOwnerService = _getComponentOwnerService();

        _componentName = name;
        _componentType = componentType;
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

    function setId(uint256 id) external onlyComponent { _componentId = id; }
    function setState(uint16 state) external onlyComponent { _componentState = state; }

    function getName() public view returns(bytes32) { return _componentName; }
    function getId() public view returns(uint256) { return _componentId; }
    function getType() public view returns(uint16) { return _componentType; }
    function getState() public view returns(uint16) { return _componentState; }
    function getOwner() external view returns(address) { return owner(); }

    function productType() public view returns(uint16) { return PRODUCT_TYPE; }
    function oracleType() public view returns(uint16) { return ORACLE_TYPE; }
    function riskpoolType() public view returns(uint16) { return RISKPOOL_TYPE; }

    function isProduct() public view returns(bool) { return _componentType == PRODUCT_TYPE; }
    function isOracle() public view returns(bool) { return _componentType == ORACLE_TYPE; }
    function isRiskpool() public view returns(bool) { return _componentType == RISKPOOL_TYPE; }

    function getRequiredRole() public view override returns(bytes32) { return _requiredRole; }

    function getRequiredAssets() 
        public 
        view 
        override 
        returns(
            address [] memory tokens, 
            uint256 [] memory amounts)
    {
        require(_requiredStakingDefined, "ERROR:CMP-005:REQUIRED_STAKING_UNDEFINED");
        return (_requiredTokens, _requiredAmounts);
    }

    function _afterPropose() internal virtual {}
    function _afterApprove() internal virtual {}
    function _afterDecline() internal virtual {}

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
