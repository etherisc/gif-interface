// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract IdSet {

    mapping(uint256 => uint256) private _idMap;
    uint256 [] _ids;

    function _addIdToSet(uint256 id) internal {
        if(_idMap[id] == 0) {
            _ids.push(id);
            _idMap[id] = _ids.length;
        }
    }

    function _removeIdfromSet(uint256 id) internal {
        uint256 idx = _idMap[id];
        if(idx > 0) {
            idx -= 1;
            _ids[idx] = _ids[_ids.length - 1];
            _ids.pop();
            delete _idMap[id];
        }
    }

    function _containsIdInSet(uint256 id) internal view returns(bool) {
        return _idMap[id] > 0;
    }

    function _idSetSize() internal view returns(uint256) {
        return _ids.length;
    }

    function _idInSetAt(uint256 idx) internal view returns(uint256 id) {
        require(idx < _ids.length, "ERROR:SET-001:INDEX_TOO_LARGE");
        return _ids[idx];
    }
}