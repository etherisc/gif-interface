// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./Riskpool.sol";
import "../modules/IBundle.sol";
import "../modules/IPolicy.sol";

// basic riskpool always collateralizes one application using exactly one bundle
abstract contract BasicRiskpool is Riskpool {

    // remember bundleId for each processId
    // approach only works for basic risk pool where a
    // policy is collateralized by exactly one bundle
    // processId -> bundleId
    mapping(bytes32 => uint256) internal _collateralizedBy;

    constructor(
        bytes32 name,
        uint256 collateralization,
        address wallet,
        address registry
    )
        Riskpool(name, collateralization, wallet, registry)
    { }

    // needs to remember which bundles helped to cover ther risk
    // simple (retail) approach: single policy covered by single bundle
    // first bundle with a match and sufficient capacity wins
    // Component <- Riskpool <- BasicRiskpool <- TestRiskpool
    // complex (wholesale) approach: single policy covered by many bundles
    // Component <- Riskpool <- AdvancedRiskpool <- TestRiskpool
    function _lockCollateral(bytes32 processId, uint256 collateralAmount) 
        internal override
        returns(bool success) 
    {
        uint256 activeBundles = _idSetSize();
        uint256 capital = getCapital();
        uint256 lockedCapital = getTotalValueLocked();

        require(activeBundles > 0, "ERROR:BRP-001:NO_ACTIVE_BUNDLES");
        require(capital > lockedCapital, "ERROR:BRP-002:NO_FREE_CAPITAL");

        // ensure there is a chance to find the collateral
        if(capital >= lockedCapital + collateralAmount) {
            IPolicy.Application memory application = _instanceService.getApplication(processId);

            // basic riskpool implementation: policy coverage by single bundle only
            uint i;
            while (i < activeBundles && !success) {
                uint256 bundleId = _idInSetAt(i);
                IBundle.Bundle memory bundle = _instanceService.getBundle(bundleId);
                bool isMatching = bundleMatchesApplication(bundle, application);
                emit LogRiskpoolBundleMatchesPolicy(bundleId, isMatching);

                if (isMatching) {
                    uint256 maxAmount = bundle.capital - bundle.lockedCapital;

                    if (maxAmount >= collateralAmount) {
                        _riskpoolService.collateralizePolicy(bundleId, processId, collateralAmount);
                        _collateralizedBy[processId] = bundleId;
                        success = true;
                    } else {
                        i++;
                    }
                }
            }
        }
    }


    function _increaseBundleBalances(bytes32 processId, uint256 amount)
        internal override 
    {
        uint256 bundleId = _collateralizedBy[processId];
        _riskpoolService.increaseBundleBalance(bundleId, processId, amount);
    }


    function _decreaseBundleBalances(bytes32 processId, uint256 amount)
        internal override 
    {
        uint256 bundleId = _collateralizedBy[processId];
        _riskpoolService.decreaseBundleBalance(bundleId, processId, amount);
    }


    function _releaseCollateral(bytes32 processId) 
        internal override
        returns(uint256 collateralAmount) 
    {        
        uint256 bundleId = _collateralizedBy[processId];
        collateralAmount = _riskpoolService.releasePolicy(bundleId, processId);
    }
}