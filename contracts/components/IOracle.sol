// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IComponent.sol";

interface IOracle is IComponent {
    
    event LogOracleCreated (address oracleAddress);
    event LogOracleProposed (uint256 id);
    event LogOracleApproved (uint256 id);
    event LogOracleDeclined (uint256 id);
    
    function request(uint256 requestId, bytes calldata input) external;
}
