// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface ICoreProxy {

    event LogCoreContractUpgraded (
        address oldImplementation, 
        address newImplemntation
    );

}
