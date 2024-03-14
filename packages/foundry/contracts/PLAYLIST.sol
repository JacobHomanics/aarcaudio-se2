//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

import {StructuredLinkedList} from "solidity-linked-list/contracts/StructuredLinkedList.sol";

contract PLAYLIST is Ownable {
    using StructuredLinkedList for StructuredLinkedList.List;

    StructuredLinkedList.List LIST;
    struct BASE_STRCTURE {
        address value;
    }

    mapping(uint256 => BASE_STRCTURE) private S_STRUCTURE_MAP;
    uint256 S_PROGRESSIVE_ID = 0;

    constructor(address OWNER) Ownable(OWNER) {}

    function CREATE_STRUCTURE(address SONG) public onlyOwner {
        S_PROGRESSIVE_ID = S_PROGRESSIVE_ID + 1;
        S_STRUCTURE_MAP[S_PROGRESSIVE_ID] = BASE_STRCTURE(SONG);
    }

    function ADD_SONG(address SONG) public onlyOwner {
        CREATE_STRUCTURE(SONG);
        uint256 TOKEN_ID = S_PROGRESSIVE_ID;
        LIST.pushBack(TOKEN_ID);
    }

    function ADD_SONGS_BATCH(address[] memory SONGS) external onlyOwner {
        for (uint256 i = 0; i < SONGS.length; i++) {
            ADD_SONG(SONGS[i]);
        }
    }

    function REMOVE_SONG(address song) public onlyOwner {
        uint256 SIZE_OF = LIST.sizeOf();

        uint256 SELECTED_NODE = 0;

        for (uint256 i = 1; i <= SIZE_OF; i++) {
            (bool EXISTS, uint256 NEXT) = LIST.getNextNode(SELECTED_NODE);
            SELECTED_NODE = NEXT;

            if (EXISTS) {
                if (S_STRUCTURE_MAP[SELECTED_NODE].value == song) {
                    LIST.remove(SELECTED_NODE);
                }
            }
        }
    }

    function REMOVE_SONGS_BATCH(address[] memory SONGS) external onlyOwner {
        for (uint256 i = 0; i < SONGS.length; i++) {
            REMOVE_SONG(SONGS[i]);
        }
    }

    function GET_SONG_BY_INDEX(
        uint256 INDEX
    ) external view returns (address song) {
        uint256 SIZE_OF = LIST.sizeOf();

        uint256 SELECTED_NODE = 0;

        for (uint256 i = 1; i <= SIZE_OF; i++) {
            (bool EXISTS, uint256 NEXT) = LIST.getNextNode(SELECTED_NODE);
            SELECTED_NODE = NEXT;

            if (EXISTS) {
                if (i == INDEX) {
                    song = S_STRUCTURE_MAP[SELECTED_NODE].value;
                }
            }
        }
    }

    function GET_ALL_SONGS() external view returns (address[] memory) {
        uint256 SIZE_OF = LIST.sizeOf();

        address[] memory SONGS = new address[](SIZE_OF);
        uint256 SELECTED_NODE = 0;

        for (uint256 i = 1; i <= SIZE_OF; i++) {
            (bool EXISTS, uint256 NEXT) = LIST.getNextNode(SELECTED_NODE);
            SELECTED_NODE = NEXT;

            if (EXISTS) {
                SONGS[i - 1] = S_STRUCTURE_MAP[SELECTED_NODE].value;
            }
        }

        return SONGS;
    }

    function GET_PROGRESSIVE_ID() external view returns (uint256) {
        return S_PROGRESSIVE_ID;
    }
}
