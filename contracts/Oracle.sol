// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IOracle.sol";
import "./RBAC.sol";
import "./IOracleService.sol";
import "./IOracleOwnerService.sol";
import "./IRegistryAccess.sol";

abstract contract Oracle is IOracle, RBAC {
    IOracleService public oracleService;
    IOracleOwnerService public oracleOwnerService;
    IRegistryAccess public registryAccess;

    modifier onlyQuery {
        require(
            msg.sender == registryAccess.getContractFromRegistry("Query"),
            "ERROR:ORA-001:ACCESS_DENIED"
        );
        _;
    }

    constructor(
        address _oracleService,
        address _oracleOwnerService,
        bytes32 _oracleTypeName,
        bytes32 _oracleName
    )
    {
        oracleService = IOracleService(_oracleService);
        oracleOwnerService = IOracleOwnerService(_oracleOwnerService);
        registryAccess = IRegistryAccess(_oracleService);

        uint256 oracleId = oracleOwnerService.proposeOracle(_oracleName);
        oracleOwnerService.proposeOracleToOracleType(_oracleTypeName, oracleId);
    }

    function _respond(uint256 _requestId, bytes memory _data) internal {
        oracleService.respond(_requestId, _data);
    }
}
