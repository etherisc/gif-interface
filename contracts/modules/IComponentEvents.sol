// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "../components/IComponent.sol";

interface IComponentEvents {

    event LogComponentCreated (
        bytes32 componentName,
        ComponentType componentType,
        address componentAddress,
        address registry
    );

    event LogComponentProposed (
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
