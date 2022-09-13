// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.2;

interface ICoreProxy {

    event LogCoreContractUpgraded (
        address oldImplementation, 
        address newImplemntation
    );

}
