// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {SONG} from "../contracts/SONG.sol";
import {PLAYLIST} from "../contracts/PLAYLIST.sol";
import {ALBUM} from "../contracts/ALBUM.sol";
import {MockAggregatorV2V3Interface} from "../contracts/chainlink/mocks/MockAggregatorV2V3Interfacel.sol";

// import {ALBUM_REDEMPTION} from "../contracts/ALBUM_REDEMPTION.sol";

contract YourContractTest is Test {
    address s_artist;
    address s_user;

    SONG song1;
    SONG song2;
    SONG song3;
    SONG song4;

    function setUp() public {
        s_artist = vm.addr(1);
        s_user = vm.addr(2);

        console.log("Artist: ", address(s_artist));
        console.log("User: ", address(s_user));

        MockAggregatorV2V3Interface aggregator = new MockAggregatorV2V3Interface();

        PLAYLIST playlist = new PLAYLIST(s_artist);

        address[] memory admins = new address[](1);
        admins[0] = s_artist;

        ALBUM album = new ALBUM(
            address(playlist),
            s_artist,
            admins,
            "Album 1",
            "A1",
            "ipfs",
            "ipfs2",
            address(aggregator),
            6000
        );

        address[] memory songAdmins = new address[](1);
        songAdmins[0] = address(album);

        song1 = new SONG(
            s_artist,
            "Song 1",
            "S1",
            0.1 ether,
            "ipfs",
            address(aggregator),
            25,
            songAdmins
        );
        console.log("Song1:", address(song1));
        song2 = new SONG(
            s_artist,
            "Song 2",
            "S2",
            0.1 ether,
            "ipfs",
            address(aggregator),
            25,
            songAdmins
        );
        console.log("Song2:", address(song2));
        song3 = new SONG(
            s_artist,
            "Song 3",
            "S3",
            0.1 ether,
            "ipfs",
            address(aggregator),
            25,
            songAdmins
        );
        console.log("Song3:", address(song3));
        song4 = new SONG(
            s_artist,
            "Song 4",
            "S4",
            0.1 ether,
            "ipfs",
            address(aggregator),
            25,
            songAdmins
        );
        console.log("Song4:", address(song4));

        // ALBUM_REDEMPTION album_redemption = new ALBUM_REDEMPTION(
        //     s_artist,
        //     address(playlist),
        //     address(album)
        // );

        // vm.startPrank(s_artist);
        // album.grantRole(album.DEFAULT_ADMIN_ROLE(), address(album_redemption));
        // vm.stopPrank();

        vm.startPrank(s_artist);
        playlist.ADD_SONG(address(song1));
        playlist.ADD_SONG(address(song2));
        playlist.ADD_SONG(address(song3));
        playlist.ADD_SONG(address(song4));
        // playlist.REMOVE_SONG(address(song2));
        vm.stopPrank();

        address[] memory songs = playlist.getAllSongs();
        for (uint256 i = 0; i < songs.length; i++) {
            console.log(songs[i]);
        }

        console.log(album.CHECK_IF_OWNS_COLLECTION(s_user));

        vm.deal(s_user, 0.4 ether);

        vm.startPrank(s_user);
        song1.MINT{value: 0.1 ether}(s_user);
        song2.MINT{value: 0.1 ether}(s_user);
        song3.MINT{value: 0.1 ether}(s_user);
        song4.MINT{value: 0.1 ether}(s_user);
        vm.stopPrank();

        console.log(album.CHECK_IF_OWNS_COLLECTION(s_user));

        album.claim(s_user);
        console.log(album.balanceOf(s_user));

        console.log(album.ownerOf(0));

        vm.startPrank(s_user);
        song2.transferFrom(s_user, s_artist, 0);
        vm.stopPrank();

        console.log(album.balanceOf(s_user));

        console.log(album.ownerOf(0));

        console.log(playlist.getSongByIndex(4));
        console.log(playlist.getSongByIndex(1));
        console.log(playlist.getSongByIndex(3));
        console.log(playlist.getSongByIndex(2));
    }

    function testMe() public {}

    function generateRandomNumber(uint256 seed) public view returns (uint256) {
        uint256 blockNumber = block.number;
        bytes32 blockHash = blockhash(blockNumber);
        return (uint256(blockHash) % seed);
    }

    function testPriceFeed() public {
        int i = song1.getChainlinkDataFeedLatestAnswer();

        console.logInt(i);

        uint cents = 25;
        // uint currentFiatPrice = 77697017 * 1e10;
        uint currentFiatPrice = 40000000 * 1e10;
        // uint currentFiatPrice = uint256(i) * 1e10;
        uint fiatPrice = cents * 1e16;

        uint ethValue = (fiatPrice * 1e18) / currentFiatPrice;

        console.log(ethValue);
    }

    // 6250000000000000000000
    // 625000000000000000

    // function testMe3(
    //     TOKEN_INFORMATION[] memory TOKEN_INFORMATIONS,
    //     uint256 numToMint
    // ) public {
    //     vm.assume(numToMint < 30);
    //     vm.assume(TOKEN_INFORMATIONS.length < 100);
    //     vm.assume(TOKEN_INFORMATIONS.length > 0);

    //     for (uint256 i = 0; i < TOKEN_INFORMATIONS.length; i++) {
    //         vm.assume(TOKEN_INFORMATIONS[i].PRICE < 1000000 ether);
    //     }

    //     initialize(TOKEN_INFORMATIONS);

    //     address user = vm.addr(1);

    //     vm.warp(10000000);

    //     for (uint256 i = 0; i < numToMint; i++) {
    //         uint256 rn = generateRandomNumber(TOKEN_INFORMATIONS.length);
    //         vm.deal(user, TOKEN_INFORMATIONS[rn].PRICE);
    //         vm.prank(user);
    //         yourContract.MINT{value: TOKEN_INFORMATIONS[rn].PRICE}(user, rn);
    //         // assertEq(yourContract.tokenURI(i), TOKEN_INFORMATIONS[rn].URI);
    //         // assertEq(user.balance, 0 ether);
    //     }
    // }
}
