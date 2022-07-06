// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponent.sol";
import "../modules/IBundle.sol";

interface IRiskpool is IComponent {

    function createBundle(bytes calldata filter, uint256 initialAmount) external returns(uint256 bundleId);

    function securePolicy(bytes32 processId) external returns(bool isSecured);
    function expirePolicy(bytes32 processId) external;

    function securePayout(bytes32 processId, uint256 payoutId, uint256 amount) external;
    function executePayout(bytes32 processId, uint256 payoutId) external;

    function getFilterDataStructure() external view returns(string memory);

    function getCollateralizationDecimals() external view returns (uint256);
    function getCollateralizationLevel() external view returns (uint256);

    function bundles() external view returns(uint256);
    function getBundle(uint256 idx) external view returns(IBundle.Bundle memory);

    function getCapacity() external view returns(uint256); 
    function getTotalValueLocked() external view returns(uint256); 
    function getPrice() external view returns(uint256); 
}
