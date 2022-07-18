// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IdSet.sol";
import "./IRiskpool.sol";
import "./Component.sol";

import "../modules/IBundle.sol";
import "../modules/IPolicy.sol";
import "../services/IInstanceService.sol";
import "../services/IRiskpoolService.sol";

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// TODO consider to move bunlde per riskpool book keeping to bundle controller
abstract contract Riskpool is 
    IRiskpool, 
    IdSet,
    Component 
{    
    // used for representation of collateralization
    // collateralization between 0 and 1 (1=100%) 
    // value might be larger when overcollateralization
    uint256 public constant FULL_COLLATERALIZATION_LEVEL = 10**18;
    string public constant DEFAULT_FILTER_DATA_STRUCTURE = "";

    IInstanceService internal _instanceService; 
    IRiskpoolService internal _riskpoolService;
    IERC721 internal _bundleToken;
    
    // keep track of bundles associated with this riskpool
    uint256 [] internal _bundleIds;

    address private _wallet;
    uint256 private _collateralization;
    uint256 private _capital;
    uint256 private _lockedCapital;
    uint256 private _balance;

    modifier onlyPool {
        require(
             _msgSender() == _getContractAddress("Pool"),
            "ERROR:RPL-001:ACCESS_DENIED"
        );
        _;
    }

    modifier onlyBundleOwner(uint256 bundleId) {
        IBundle.Bundle memory bundle = _instanceService.getBundle(bundleId);
        address bundleOwner = _bundleToken.ownerOf(bundle.tokenId);

        require(
            _msgSender() == bundleOwner,
            "ERROR:BUC-001:NOT_BUNDLE_OWNER"
        );
        _;
    }

    constructor(
        bytes32 name,
        uint256 collateralization,
        address wallet,
        address registry
    )
        Component(name, ComponentType.Riskpool, registry)
    { 
        require(collateralization != 0, "ERROR:RPL-002:COLLATERALIZATION_ZERO");
        _collateralization = collateralization;

        require(wallet != address(0), "ERROR:RPL-003:WALLET_ADDRESS_ZERO");
        _wallet = wallet;

        _instanceService = IInstanceService(_getContractAddress("InstanceService")); 
        _riskpoolService = IRiskpoolService(_getContractAddress("RiskpoolService"));
        _bundleToken = _instanceService.getBundleToken();
    }

    // TODO decide on authz for bundle creation
    function createBundle(bytes calldata filter, uint256 initialAmount) 
        external override
        returns(uint256 bundleId)
    {
        address bundleOwner = _msgSender();
        bundleId = _riskpoolService.createBundle(bundleOwner, filter, initialAmount);
        _bundleIds.push(bundleId);

        IBundle.Bundle memory bundle = _instanceService.getBundle(bundleId);
        if (bundle.state == IBundle.BundleState.Active) {
            _addIdToSet(bundleId);
        }
        
        // update financials
        _capital += bundle.capital;
        _balance += bundle.capital;

        emit LogRiskpoolBundleCreated(bundleId, initialAmount);
    }

    function fundBundle(uint256 bundleId, uint256 amount) 
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.fundBundle(bundleId, amount);
    }

    function defundBundle(uint256 bundleId, uint256 amount)
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.defundBundle(bundleId, amount);
    }

    function lockBundle(uint256 bundleId)
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.lockBundle(bundleId);
    }

    function unlockBundle(uint256 bundleId)
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.unlockBundle(bundleId);
    }

    function closeBundle(uint256 bundleId)
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.closeBundle(bundleId);
    }

    function burnBundle(uint256 bundleId)
        external override
        onlyBundleOwner(bundleId)
    {
        _riskpoolService.burnBundle(bundleId);
    }

    function collateralizePolicy(bytes32 processId) 
        external override
        onlyPool
        returns(bool success) 
    {
        IPolicy.Application memory application = _instanceService.getApplication(processId);
        uint256 sumInsured = application.sumInsuredAmount;
        uint256 collateralAmount = calculateCollateral(application);
        emit LogRiskpoolRequiredCollateral(processId, sumInsured, collateralAmount);

        success = _lockCollateral(processId, collateralAmount);
        if (success) {
            _lockedCapital += collateralAmount;
        }

        emit LogRiskpoolCollateralLocked(processId, collateralAmount, success);
    }


    function increaseBalance(bytes32 processId, uint256 amount)
        external override
        onlyPool
    {
        _increaseBundleBalances(processId, amount);
        _balance += amount;

        emit LogRiskpoolBalanceIncreased(processId, amount, _balance);
    }

    function decreaseBalance(bytes32 processId, uint256 amount)
        external override
        onlyPool
    {
        require(_balance > amount, "ERROR:RPL-005:RISKPOOL_BALANCE_TOO_LOW");

        _decreaseBundleBalances(processId, amount);
        _balance -= amount;
        
        emit LogRiskpoolBalanceDecreased(processId, amount, _balance);
    }


    function releasePolicy(bytes32 processId) 
        external override
        onlyPool
    {
        uint256 collateralAmount = _releaseCollateral(processId);
        require(
            collateralAmount <= _lockedCapital,
            "ERROR:RPL-005:FREED_COLLATERAL_TOO_BIG"
        );

        _lockedCapital -= collateralAmount;
    }

    function preparePayout(bytes32 processId, uint256 payoutId, uint256 amount) external override {
        revert("ERROR:RPL-991:SECURE_PAYOUT_NOT_IMPLEMENTED");
    }

    function executePayout(bytes32 processId, uint256 payoutId) external override {
        revert("ERROR:RPL-991:EXECUTE_PAYOUT_NOT_IMPLEMENTED");
    }

    function getFullCollateralizationLevel() public pure override returns (uint256) {
        return FULL_COLLATERALIZATION_LEVEL;
    }

    function getCollateralizationLevel() public view override returns (uint256) {
        return _collateralization;
    }

    function calculateCollateral(IPolicy.Application memory application) 
        public override
        view 
        returns (uint256 collateralAmount) 
    {
        uint256 sumInsured = application.sumInsuredAmount;
        uint256 collateralization = getCollateralizationLevel();

        // fully collateralized case
        if (collateralization == FULL_COLLATERALIZATION_LEVEL) {
            collateralAmount = sumInsured;
        // over or under collateralized case
        } else {
            collateralAmount = (collateralization * sumInsured) / FULL_COLLATERALIZATION_LEVEL;
        }
    }

    function bundles() public override view returns(uint256) {
        return _bundleIds.length;
    }

    function getBundle(uint256 idx) public override view returns(IBundle.Bundle memory) {
        require(idx < _bundleIds.length, "ERROR:RPL-006:BUNDLE_INDEX_TOO_LARGE");

        uint256 bundleIdx = _bundleIds[idx];
        return _instanceService.getBundle(bundleIdx);
    }

    function getFilterDataStructure() external override pure returns(string memory) {
        return DEFAULT_FILTER_DATA_STRUCTURE;
    }

    function getCapital() public override view returns(uint256) {
        return _capital;
    }

    function getTotalValueLocked() public override view returns(uint256) {
        return _lockedCapital;
    }

    function getCapacity() public override view returns(uint256) {
        return _capital - _lockedCapital;
    }

    function getBalance() public override view returns(uint256) {
        return _balance;
    }

    function bundleMatchesApplication(
        IBundle.Bundle memory bundle, 
        IPolicy.Application memory application
    ) public override view virtual returns(bool isMatching);

    function _lockCollateral(bytes32 processId, uint256 collateralAmount) internal virtual returns(bool success);
    function _releaseCollateral(bytes32 processId) internal virtual returns(uint256 collateralAmount);

    function _increaseBundleBalances(bytes32 processId, uint256 amount) internal virtual;
    function _decreaseBundleBalances(bytes32 processId, uint256 amount) internal virtual;
}