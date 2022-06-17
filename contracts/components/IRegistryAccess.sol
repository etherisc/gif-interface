// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IRegistryAccess {
    
    function getContractFromRegistry(bytes32 _contractName) 
        external 
        view 
        returns (address _contractAddress);
}
