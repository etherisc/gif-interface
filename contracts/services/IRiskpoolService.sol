// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IRiskpoolService {

    function registerRiskpool(
        address wallet,
        address erc20Token,
        uint256 collateralization, 
        uint256 sumOfSumInsuredCap
    ) external;

    function createBundle(address owner_, bytes calldata filter_, uint256 amount_) external returns(uint256 bundleId);
    function fundBundle(uint256 bundleId, uint256 amount) external returns(bool success, uint256 netAmount);
    function defundBundle(uint256 bundleId, uint256 amount) external returns(bool success, uint256 netAmount);

    function lockBundle(uint256 bundleId) external;
    function unlockBundle(uint256 bundleId) external;
    function closeBundle(uint256 bundleId) external;
    function burnBundle(uint256 bundleId) external;

    function collateralizePolicy(uint256 bundleId, bytes32 processId, uint256 collateralAmount) external;
    function releasePolicy(uint256 bundleId, bytes32 processId) external returns(uint256 collateralAmount);

    function increaseBundleBalance(uint256 bundleId, bytes32 processId, uint256 amount) external returns(uint256 newBalance);
    function decreaseBundleBalance(uint256 bundleId, bytes32 processId, uint256 amount) external returns(uint256 newBalance);
}

