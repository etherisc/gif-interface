// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPool {

    event LogRiskpoolCollateralizationFailed(uint256 riskpoolId, bytes32 processId, uint256 amount);
    event LogRiskpoolCollateralizationSucceeded(uint256 riskpoolId, bytes32 processId, uint256 amount);

    struct Pool {
        uint256 id; // matches component id of riskpool
        uint256 sumOfSumInsuredCap; // max sum of sum insured the pool is allowed to secure
        uint256 sumOfSumInsuredAtRisk; // current sum of sum insured at risk in this pool
        uint256 collateralizationLevel;
        uint256 capital;
        uint256 lockedCapital;
        uint256 balance;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function setRiskpoolForProduct(uint256 productId, uint256 riskpoolId) external;

    function underwrite(bytes32 processId) external returns(bool success);
    function release(bytes32 processId) external; 

    function increaseBalance(bytes32 processId, uint256 amount) external;
    function decreaseBalance(bytes32 processId, uint256 amount) external;
}
