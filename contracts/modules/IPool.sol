// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IPool {

    event LogRiskpoolRegistered(
        uint256 riskpoolId, 
        address wallet,
        address erc20Token, 
        uint256 collateralizationLevel, 
        uint256 sumOfSumInsuredCap
    );
    
    event LogRiskpoolCollateralizationFailed(uint256 riskpoolId, bytes32 processId, uint256 amount);
    event LogRiskpoolCollateralizationSucceeded(uint256 riskpoolId, bytes32 processId, uint256 amount);

    struct Pool {
        uint256 id; // matches component id of riskpool
        address wallet; // riskpool wallet
        address erc20Token; // the value token of the riskpool
        uint256 collateralizationLevel;
        uint256 sumOfSumInsuredCap; // max sum of sum insured the pool is allowed to secure
        uint256 sumOfSumInsuredAtRisk; // current sum of sum insured at risk in this pool
        uint256 capital;
        uint256 lockedCapital;
        uint256 balance;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function registerRiskpool(
        address wallet,
        uint256 sumOfSumInsuredCap, // max sum of sum insured the pool is allowed to secure
        uint256 collateralizationLevel
    ) external;

    function setRiskpoolForProduct(uint256 productId, uint256 riskpoolId) external;

    function underwrite(bytes32 processId) external returns(bool success);
    function release(bytes32 processId) external; 

    function increaseBalance(bytes32 processId, uint256 amount) external;
    function decreaseBalance(bytes32 processId, uint256 amount) external;
}
