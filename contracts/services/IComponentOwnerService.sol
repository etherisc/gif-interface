// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "../components/IComponent.sol";

interface IComponentOwnerService {

    function propose(IComponent component) external;

    function stake(uint256 id, address [] calldata tokens, uint256 [] calldata amounts) external; // only owner, set of tokens, amounts
    function withdraw(uint256 id, address [] calldata tokens, uint256 [] calldata amounts) external; // only owner, set of tokens, amounts

    function pause(uint256 id) external; // only owner, only when active, set to paused
    function unpause(uint256 id) external; // only owner, only when paused, set to active
}