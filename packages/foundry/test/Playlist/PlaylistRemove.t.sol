// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {SONG} from "../../contracts/SONG.sol";
import {PLAYLIST} from "../../contracts/PLAYLIST.sol";
import {ALBUM} from "../../contracts/ALBUM.sol";
import {MockAggregatorV2V3Interface} from "../../contracts/chainlink/mocks/MockAggregatorV2V3Interface.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract PlaylistTest is Test {
    using Strings for uint256;

    address s_playlistOwner;
    address s_songOwner;

    PLAYLIST s_playlist;

    int256 priceOfEthereum = 400000000000;

    address[] songAdmins;

    address[] s_songs;

    function setUp() public {
        s_playlistOwner = vm.addr(1);
        s_songOwner = vm.addr(2);

        console.log("Playlist Owner: ", address(s_playlistOwner));

        songAdmins.push(vm.addr(3));

        s_playlist = new PLAYLIST(s_playlistOwner);
        console.log("Playlist: ", address(s_playlist));

        vm.startPrank(s_playlistOwner);
        s_songs = generateAddress(100);
        s_playlist.ADD_SONGS_BATCH(s_songs);
        vm.stopPrank();
    }

    function testRemoveSong(uint256 index) public {
        vm.assume(index < s_songs.length);

        vm.startPrank(s_playlistOwner);
        s_playlist.REMOVE_SONG(s_songs[index]);
        vm.stopPrank();
    }

    function testRevertRemoveSong(address badActor, uint256 index) public {
        vm.assume(index < s_songs.length);
        vm.assume(badActor != s_playlistOwner);

        vm.startPrank(badActor);
        vm.expectRevert();
        s_playlist.REMOVE_SONG(s_songs[index]);
        vm.stopPrank();
    }

    function testRemoveSongBatch() public {
        vm.startPrank(s_playlistOwner);
        s_playlist.REMOVE_SONGS_BATCH(s_songs);
        vm.stopPrank();
    }

    function testRevertRemoveSongBatch(address badActor) public {
        vm.assume(badActor != s_playlistOwner);

        vm.startPrank(badActor);
        vm.expectRevert();
        s_playlist.REMOVE_SONGS_BATCH(s_songs);
        vm.stopPrank();
    }

    function generateAddress(
        uint256 number
    ) public pure returns (address[] memory) {
        address[] memory addresses = new address[](number);
        for (uint256 i = 0; i < addresses.length; i++) {
            addresses[i] = vm.addr(i + 1);
        }

        return addresses;
    }
}
