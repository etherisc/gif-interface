// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

interface ILicense {

    function getAuthorizationStatus(address _sender)
        external
        view
        returns (uint256 productId, bool isAuthorized, address policyFlow);

    function getProductId(address sender) 
        external 
        view 
        returns(uint256 productId);
}
