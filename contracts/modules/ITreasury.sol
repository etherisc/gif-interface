// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITreasury {

    event LogTreasuryProductTokenSet (uint256 productId, uint256 riskpoolId, address erc20Address);
    event LogTreasuryInstanceWalletSet (address walletAddress);
    event LogTreasuryRiskpoolWalletSet (uint256 riskpoolId, address walletAddress);

    event LogTreasuryPremiumTransferred (address from, address riskpoolWalletAddress, uint256 amount, bool success);
    event LogTreasuryCapitalTransferred (address from, address riskpoolWalletAddress, uint256 amount, bool success);
    event LogTreasuryFeesTransferred (address from, address instanceWalletAddress, uint256 amount, bool success);

    event LogTreasuryPremiumFeesSet (uint256 productId, uint256 fixedFee, uint256 fractionalFee);
    event LogTreasuryCapitalFeesSet (uint256 riskpoolId, uint256 fixedFee, uint256 fractionalFee);

    event LogTreasuryPremiumProcessed (bytes32 processId, uint256 amount, bool success);
    event LogTreasuryCapitalProcessed (uint256 riskpoolId, uint256 bundleId, uint256 amount, bool success);

    struct FeeSpecification {
        uint256 componentId;
        uint256 fixedFee;
        uint256 fractionalFee;
        bytes feeCalculationData;
        uint256 createdAt;
        uint256 updatedAt;
    }

    function setProductToken(uint256 productId, address erc20Address) external;

    function setInstanceWallet(address instanceWalletAddress) external;
    function setRiskpoolWallet(uint256 riskpoolId, address riskpoolWalletAddress) external;

    function createFeeSpecification(
        uint256 componentId,
        uint256 fixedFee,
        uint256 fractionalFee,
        bytes calldata feeCalculationData
    )
        external view returns(FeeSpecification memory feeSpec);
    
    function setPremiumFees(FeeSpecification calldata feeSpec) external;
    function setCapitalFees(FeeSpecification calldata feeSpec) external;
    
    function processPremium(bytes32 processId) external returns(bool success);
    function processCapital(uint256 bundleId, uint256 capitalAmount) external 
        returns(
            bool success,
            uint256 capitalAfterFees
        );

    function getComponentToken(uint256 componentId) external view returns(IERC20 token);
    function getFeeSpecification(uint256 componentId) external view returns(FeeSpecification memory feeSpecification);

    function getFractionFullUnit() external view returns(uint256);
    function getInstanceWallet() external view returns(address instanceWalletAddress);
    function getRiskpoolWallet(uint256 riskpoolId) external view returns(address riskpoolWalletAddress);

}
