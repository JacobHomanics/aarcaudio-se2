//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StructuredLinkedList} from "solidity-linked-list/contracts/StructuredLinkedList.sol";

contract PLAYLIST is Ownable {
    using StructuredLinkedList for StructuredLinkedList.List;

    StructuredLinkedList.List LIST;
    struct BaseStructure {
        address value;
    }

    // Mapping from token ID to the structures
    mapping(uint256 => BaseStructure) private _structureMap;
    uint256 public progressiveId = 0;

    function createStructure(address song) public {
        progressiveId = progressiveId + 1;
        _structureMap[progressiveId] = BaseStructure(song);
    }

    constructor(address OWNER) Ownable(OWNER) {}

    function ADD_SONG(address song) external onlyOwner {
        createStructure(song);
        uint256 tokenId = progressiveId;
        LIST.pushBack(tokenId);
    }

    function REMOVE_SONG(address song) external onlyOwner {
        uint256 sizeOf = LIST.sizeOf();

        uint256 selectedNode = 0;

        for (uint256 i = 1; i <= sizeOf; i++) {
            (bool exists, uint256 next) = LIST.getNextNode(selectedNode);
            selectedNode = next;

            if (exists) {
                if (_structureMap[selectedNode].value == song) {
                    LIST.remove(selectedNode);
                }
            }
        }
    }

    function getSongByIndex(
        uint256 index
    ) external view returns (address song) {
        uint256 sizeOf = LIST.sizeOf();

        uint256 selectedNode = 0;

        for (uint256 i = 1; i <= sizeOf; i++) {
            (bool exists, uint256 next) = LIST.getNextNode(selectedNode);
            selectedNode = next;

            if (exists) {
                if (i == index) {
                    song = _structureMap[selectedNode].value;
                }
            }
        }
    }

    function getAllSongs() external view returns (address[] memory) {
        uint256 sizeOf = LIST.sizeOf();

        address[] memory songs = new address[](sizeOf);
        uint256 selectedNode = 0;

        for (uint256 i = 1; i <= sizeOf; i++) {
            (bool exists, uint256 next) = LIST.getNextNode(selectedNode);
            selectedNode = next;

            if (exists) {
                songs[i - 1] = _structureMap[selectedNode].value;
            }
        }

        return songs;
    }

    // function getCollectionLength() public view returns (uint256) {
    //     return COLLECTION_LENGTH;
    // }

    // function getSong(uint256 id) public view returns (address) {
    //     return SONGS[id];
    // }

    // function MINT(address RECIPIENT, uint256 SONG_ID) public payable {
    //     // if (SONG_ID >= COLLECTION_LENGTH) {
    //     //     revert AARCAUDIO_VOLUME_1__INVALID_MINT_TOKEN_ID();
    //     // }

    //     // SONG(SONGS[SONG_ID]).MINT(RECIPIENT);
    // }

    // function MINT_ALL(address RECIPIENT) external payable {
    //     for (uint256 i = 0; i < COLLECTION_LENGTH; i++) {
    //         MINT(RECIPIENT, i);
    //     }
    // }
}
