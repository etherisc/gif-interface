// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IRiskpoolService {

    function createBundle(bytes calldata filter_, uint256 amount_) external returns(uint256 bundleId);

    function securePolicy(uint256 bundleId, bytes32 processId, uint256 amount) external;
    function expirePolicy(uint256 bundleId, bytes32 processId) external;

}

