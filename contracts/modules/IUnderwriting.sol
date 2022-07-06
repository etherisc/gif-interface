// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IUnderwriting {
    function setRiskpoolForProduct(uint256 productId, uint256 riskpoolId) external;
    function underwrite(bytes32 processId) external returns(bool success);
}
