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

    PLAYLIST s_playlist;

    address[] songAdmins;

    function setUp() public {
        s_playlistOwner = vm.addr(1);

        console.log("Playlist Owner: ", address(s_playlistOwner));

        s_playlist = new PLAYLIST(s_playlistOwner);
        console.log("Playlist: ", address(s_playlist));
    }

    function testAddSong(address song) public {
        vm.startPrank(s_playlistOwner);
        s_playlist.ADD_SONG(song);

        vm.stopPrank();
    }

    function testRevertAddSong(address badActor, address song) public {
        vm.assume(badActor != s_playlistOwner);

        vm.startPrank(badActor);
        vm.expectRevert();
        s_playlist.ADD_SONG(song);
        vm.stopPrank();
    }

    function testAddSongsBatch(address[] memory songs) public {
        vm.startPrank(s_playlistOwner);
        s_playlist.ADD_SONGS_BATCH(songs);
        vm.stopPrank();
    }

    function testRevertAddSongsBatch(
        address[] memory songs,
        address badActor
    ) public {
        vm.assume(badActor != s_playlistOwner);
        vm.startPrank(badActor);
        vm.expectRevert();
        s_playlist.ADD_SONGS_BATCH(songs);
        vm.stopPrank();
    }
}
