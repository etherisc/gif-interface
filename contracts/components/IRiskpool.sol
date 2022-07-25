// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponent.sol";
import "../modules/IBundle.sol";
import "../modules/IPolicy.sol";

interface IRiskpool is IComponent {

    event LogRiskpoolCreated (address riskpoolAddress);
    event LogRiskpoolProposed (uint256 id);
    event LogRiskpoolApproved (uint256 id);
    event LogRiskpoolDeclined (uint256 id);

    event LogRiskpoolBundleCreated(uint256 bundleId, uint256 amount);
    event LogRiskpoolRequiredCollateral(bytes32 processId, uint256 sumInsured, uint256 collateral);
    event LogRiskpoolBundleMatchesPolicy(uint256 bundleId, bool isMatching);
    event LogRiskpoolCollateralLocked(bytes32 processId, uint256 collateralAmount, bool isSecured);

    event LogRiskpoolBalanceIncreased(bytes32 processId, uint256 amount, uint256 newBalance);
    event LogRiskpoolBalanceDecreased(bytes32 processId, uint256 amount, uint256 newBalance);

    function createBundle(bytes memory filter, uint256 initialAmount) external returns(uint256 bundleId);
    function fundBundle(uint256 bundleId, uint256 amount) external returns(bool success, uint256 netAmount);
    function defundBundle(uint256 bundleId, uint256 amount) external returns(bool success, uint256 netAmount);

    function lockBundle(uint256 bundleId) external;
    function unlockBundle(uint256 bundleId) external;
    function closeBundle(uint256 bundleId) external;
    function burnBundle(uint256 bundleId) external;

    function collateralizePolicy(bytes32 processId) external returns(bool isSecured);
    function releasePolicy(bytes32 processId) external;

    function preparePayout(bytes32 processId, uint256 payoutId, uint256 amount) external;
    function executePayout(bytes32 processId, uint256 payoutId) external;

    function increaseBalance(bytes32 processId, uint256 amount) external;
    function decreaseBalance(bytes32 processId, uint256 amount) external;

    function getCollateralizationLevel() external view returns (uint256);
    function getFullCollateralizationLevel() external view returns (uint256);

    function calculateCollateral(IPolicy.Application memory application) 
        external view returns(uint256 collateralAmount);

    function bundleMatchesApplication(
        IBundle.Bundle memory bundle, 
        IPolicy.Application memory application
    ) 
        external view returns(bool isMatching);   
    
    function getFilterDataStructure() external view returns(string memory);

    function bundles() external view returns(uint256);
    function getBundle(uint256 idx) external view returns(IBundle.Bundle memory);

    function getCapital() external view returns(uint256);
    function getTotalValueLocked() external view returns(uint256); 
    function getCapacity() external view returns(uint256); 
    function getBalance() external view returns(uint256); 
}
