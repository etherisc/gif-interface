// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.2;

interface ILicense {

    function getAuthorizationStatus(address _sender)
        external
        view
        returns (uint256 productId, bool isAuthorized, address policyFlow);
}
