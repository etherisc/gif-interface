// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IComponentEvents {

    event LogComponentProposed (
        bytes32 componentName, 
        uint16 componentType, 
        address componentAddress,
        uint256 id);
    
    event LogComponentApproved (uint256 id);
    event LogComponentDeclined (uint256 id);

    event LogComponentSuspended (uint256 id);
    event LogComponentResumed (uint256 id);

    event LogComponentPaused (uint256 id);
    event LogComponentUnpaused (uint256 id);

    event LogComponentStateChanged (uint256 id, uint16 stateOld, uint16 stateNew);
}
