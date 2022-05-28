// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IOracleOwnerService {

    function proposeOracle(
        bytes32 _oracleName
    ) external returns (uint256 _oracleId);

}
