// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "./IProduct.sol";
import "./Component.sol";
import "../services/IInstanceService.sol";
import "../services/IProductService.sol";

abstract contract Product is
    IProduct, 
    Component 
{    
    address private _policyFlow;
    IProductService private _productService;
    IInstanceService private _instanceService;

    modifier onlyLicence {
        require(
             _msgSender() == _getContractAddress("Licence"),
            "ERROR:PRD-001:ACCESS_DENIED"
        );
        _;
    }

    modifier onlyOracle {
        require(
             _msgSender() == _getContractAddress("Query"),
            "ERROR:PRD-002:ACCESS_DENIED"
        );
        _;
    }

    constructor(
        bytes32 name,
        bytes32 policyFlow,
        address registry
    )
        Component(name, ComponentType.Product, registry)
    {
        // TODO add validation for policy flow
        _policyFlow = _getContractAddress(policyFlow);
        _productService = IProductService(_getContractAddress("ProductService"));
        _instanceService = IInstanceService(_getContractAddress("InstanceService"));

        emit LogProductCreated(address(this));
    }

    function getPolicyFlow() public view override returns(address) {
        return _policyFlow;
    }

    // default callback function implementations
    function _afterApprove() internal override { 
        uint256 id = getId();
        // TODO figure out what the ... is wrong here
        // plugging id into the event let spin brownie console
        // with history[-1].info() ...
        // plugging in a fixed value eg 999 works fine????
        emit LogProductApproved(999); 
    }

    function _afterPropose() internal override { emit LogProductProposed(getId()); }
    function _afterDecline() internal override { emit LogProductDeclined(getId()); }

    function _newApplication(
        bytes32 processId,
        uint256 premiumAmount,
        uint256 sumInsuredAmount,
        bytes calldata metaData, 
        bytes calldata applicationData 
    )
        internal
    {
        _productService.newApplication(processId, premiumAmount, sumInsuredAmount, metaData, applicationData);
    }

    function _decline(bytes32 processId) internal {
        _productService.decline(processId);
    }

    function _underwrite(bytes32 processId) internal {
        _productService.underwrite(processId);
    }

    function _expire(bytes32 processId) internal {
        _productService.expire(processId);
    }

    function _newClaim(bytes32 processId, bytes memory data) 
        internal
        returns (uint256 claimId)
    {
        claimId = _productService.newClaim(processId, data);
    }

    function _declineClaim(bytes32 processId, uint256 claimId) internal {
        _productService.declineClaim(processId, claimId);
    }

    function _confirmClaim(
        bytes32 processId,
        uint256 claimId,
        uint256 payoutAmount,
        bytes memory data
    )
        internal
        returns (uint256 _payoutId)
    {
        _payoutId = _productService.confirmClaim(processId, claimId, payoutAmount, data);
    }

    function _processPayout(
        bytes32 processId,
        uint256 payoutId,
        bool isComplete,
        bytes memory data
    )
        internal
    {
        _productService.processPayout(processId, payoutId, isComplete, data);
    }

    function _request(
        bytes32 processId,
        bytes memory input,
        string memory callbackMethodName,
        uint256 responsibleOracleId
    )
        internal
        returns (uint256 requestId)
    {
        requestId = _productService.request(
            processId,
            input,
            callbackMethodName,
            address(this),
            responsibleOracleId
        );
    }

    function _getApplicationData(bytes32 processId) internal view returns (bytes memory _data) {
        return _instanceService.getApplication(processId).data;
    }

    function _getClaimData(bytes32 processId, uint256 claimId) internal view returns (bytes memory _data) {
        return _instanceService.getClaim(processId, claimId).data;
    }

    function _getPayoutData(bytes32 processId, uint256 payoutId) internal view returns (bytes memory _data) {
        return _instanceService.getPayout(processId, payoutId).data;
    }
}
