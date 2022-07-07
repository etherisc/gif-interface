// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IRiskpoolService {

    function createBundle(address owner_, bytes calldata filter_, uint256 amount_) external returns(uint256 bundleId);

    function collateralizePolicy(uint256 bundleId, bytes32 processId, uint256 collateralAmount) external;
    function expirePolicy(uint256 bundleId, bytes32 processId) external returns(uint256 collateralAmount);
}

