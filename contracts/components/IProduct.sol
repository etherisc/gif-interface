// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface IProduct {
    event LogProductCreated (address productAddress);
    event LogProductProposed (uint256 id);
    event LogProductApproved (uint256 id);
    event LogProductDeclined (uint256 id);
    
    function getPolicyFlow() external view returns(address);
}
