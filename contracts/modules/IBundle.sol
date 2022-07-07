// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IBundle {

    event LogNewBundle(
        uint256 riskpoolId, 
        uint256 bundleId, 
        address owner,
        BundleState state
    );

    event LogBundleStateChanged(uint256 bundleId, BundleState oldState, BundleState newState);

    event LogBundleCapitalProvided(uint256 bundleId, address sender, uint256 amount);
    event LogBundleCapitalWithdrawn(uint256 bundleId, address recipient, uint256 amount);

    enum BundleState {
        Active,
        Locked,
        Closed
    }

    struct Bundle {
        uint256 id;
        address owner;
        uint256 riskpoolId;
        BundleState state;
        bytes filter;
        uint256 capital;
        uint256 lockedCapital;
        uint256 balance;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function create(uint256 riskpoolId_, bytes calldata filter_, uint256 amount_) external returns(uint256 bundleId);
    function fund(uint256 bundleId, uint256 amount) external;
    function withdraw(uint256 bundleId, uint256 amount) external;

    function lock(uint256 bundleId) external;
    function unlock(uint256 bundleId) external;
    function close(uint256 bundleId) external;

    function collateralizePolicy(uint256 bundleId, bytes32 processId, uint256 collateralAmount) external;
    function expirePolicy(uint256 bundleId, bytes32 processId) external returns(uint256 collateralAmount);
}
