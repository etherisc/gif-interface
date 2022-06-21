// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IOracleService {

    function respond(uint256 requestId, bytes calldata data) external;
}
