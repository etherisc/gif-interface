// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPool {

    event LogRiskpoolCollateralizationFailed(uint256 riskpoolId, bytes32 processId, uint256 amount);
    event LogRiskpoolCollateralizationSucceeded(uint256 riskpoolId, bytes32 processId, uint256 amount);

    function setRiskpoolForProduct(uint256 productId, uint256 riskpoolId) external;

    function underwrite(bytes32 processId) external returns(bool success);
    function release(bytes32 processId) external; 

    function increaseBalance(bytes32 processId, uint256 amount) external;
    function decreaseBalance(bytes32 processId, uint256 amount) external;
}
