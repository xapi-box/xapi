// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

contract SubAPIFeed {
    event SubAPIFeedUpdated(bytes32 indexed beaconId, ORMPData msgRoot);

    struct ORMPData {
        // ormp message count
        uint256 count;
        // ormp message root
        bytes32 root;
    }

    ORMPData internal _aggregatedData;
    // beaconId => ORMPData
    mapping(bytes32 => ORMPData) internal _dataFeeds;

    function processBeaconUpdate(bytes32 beaconId, bytes calldata data) internal {
        ORMPData memory ormpData = abi.decode(data, (ORMPData));
        _dataFeeds[beaconId] = ormpData;
        emit SubAPIFeedUpdated(beaconId, ormpData);
    }

    function getDataFeedWithId(bytes32 beaconId) public view returns (ORMPData memory msgRoot) {
        return _dataFeeds[beaconId];
    }

    function eq(ORMPData memory a, ORMPData memory b) public pure returns (bool) {
        return (a.count == b.count && a.root == b.root);
    }

    function neq(ORMPData memory a, ORMPData memory b) public pure returns (bool) {
        return (a.count != b.count || a.root != b.root);
    }
}