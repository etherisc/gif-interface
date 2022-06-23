// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IOracle {
    function request(uint256 requestId, bytes calldata input) external;
}
