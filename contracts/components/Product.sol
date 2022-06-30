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
        bytes32 _bpKey,
        bytes memory _data
    )
        internal
    {
        _productService.newApplication(_bpKey, _data);
    }

    function _underwrite(
        bytes32 _bpKey
    )
        internal
    {
        _productService.underwrite(_bpKey);
    }

    function _decline(
        bytes32 _bpKey
    )
        internal
    {
        _productService.decline(_bpKey);
    }

    function _newClaim(
        bytes32 _bpKey,
        bytes memory _data
    )
        internal
        returns (uint256 _claimId)
    {
        _claimId = _productService.newClaim(_bpKey, _data);
    }

    function _confirmClaim(
        bytes32 _bpKey,
        uint256 _claimId,
        bytes memory _data
    )
        internal
        returns (uint256 _payoutId)
    {
        _payoutId = _productService.confirmClaim(_bpKey, _claimId, _data);
    }

    function _declineClaim(
        bytes32 _bpKey,
        uint256 _claimId
    )
        internal
    {
        _productService.declineClaim(_bpKey, _claimId);
    }

    function _expire(
        bytes32 _bpKey
    )
        internal
    {
        _productService.expire(_bpKey);
    }

    function _payout(
        bytes32 _bpKey,
        uint256 _payoutId,
        bool _complete,
        bytes memory _data
    )
        internal
    {
        _productService.payout(_bpKey, _payoutId, _complete, _data);
    }

    function _request(
        bytes32 _bpKey,
        bytes memory _input,
        string memory _callbackMethodName,
        uint256 _responsibleOracleId
    )
        internal
        returns (uint256 _requestId)
    {
        _requestId = _productService.request(
            _bpKey,
            _input,
            _callbackMethodName,
            address(this),
            _responsibleOracleId
        );
    }

    function _getApplicationData(bytes32 _bpKey) internal view returns (bytes memory _data) {
        return _instanceService.getApplication(_bpKey).data;
    }

    function _getClaimData(bytes32 _bpKey, uint256 _claimId) internal view returns (bytes memory _data) {
        return _instanceService.getClaim(_bpKey, _claimId).data;
    }

    function _getApplicationData(bytes32 _bpKey, uint256 _payoutId) internal view returns (bytes memory _data) {
        return _instanceService.getPayout(_bpKey, _payoutId).data;
    }
}
