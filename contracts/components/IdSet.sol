// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

contract IdSet {

    using EnumerableSet for EnumerableSet.UintSet;

    EnumerableSet.UintSet private _idSet;

    function _addIdToSet(uint256 id) internal {
        EnumerableSet.add(_idSet, id);
    }

    function _removeIdfromSet(uint256 id) internal {
        EnumerableSet.remove(_idSet, id);
    }

    function _containsIdInSet(uint256 id) internal view returns(bool) {
        return EnumerableSet.contains(_idSet, id);
    }

    function _idSetSize() internal view returns(uint256) {
        return EnumerableSet.length(_idSet);
    }

    function _idInSetAt(uint256 idx) internal view returns(uint256 id) {
        return EnumerableSet.at(_idSet, idx);
    }
}