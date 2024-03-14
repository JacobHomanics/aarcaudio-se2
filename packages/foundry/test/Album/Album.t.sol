// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {SONG} from "../../contracts/SONG.sol";
import {PLAYLIST} from "../../contracts/PLAYLIST.sol";
import {ALBUM} from "../../contracts/ALBUM.sol";
import {MockAggregatorV2V3Interface} from "../../contracts/chainlink/mocks/MockAggregatorV2V3Interface.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract AlbumTest is Test {
    using Strings for uint256;

    address s_songOwner;
    address s_songAdmin;
    address s_playlistOwner;
    address s_albumOwner;

    address[] songAdmins;
    address[] albumAdmins;

    PLAYLIST s_playlist;
    ALBUM s_album;
    address[] s_songs;
    MockAggregatorV2V3Interface s_dataAggregator;
    MockAggregatorV2V3Interface s_uptimeSequencer;

    string goodURI = "ipfs://good";
    string badURI = "ipfs://bad";
    int256 priceOfEthereum = 400000000000;
    uint256 albumCents = 600;
    uint256 timeWarp = 200000;
    uint256 s_albumPriceBasedOnCents;

    function setUp() public {
        s_songOwner = vm.addr(1);
        // console.log("Song Owners: ", address(s_songOwner));
        s_playlistOwner = vm.addr(3);
        // console.log("Playlist Owner: ", s_playlistOwner);
        s_albumOwner = vm.addr(4);
        // console.log("Album Owner: ", s_albumOwner);

        s_playlist = new PLAYLIST(s_playlistOwner);
        // console.log("Playlist: ", address(s_playlist));

        s_dataAggregator = new MockAggregatorV2V3Interface(priceOfEthereum, 0);
        // console.log("Mock Data Aggregator", address(s_dataAggregator));
        s_uptimeSequencer = new MockAggregatorV2V3Interface(0, 0);
        // console.log("Mock Uptime Feed Sequencer", address(s_uptimeSequencer));

        s_album = new ALBUM(
            address(s_playlist),
            s_albumOwner,
            "ALBUM-1",
            "A-1",
            goodURI,
            badURI,
            address(s_dataAggregator),
            address(s_uptimeSequencer),
            albumCents
        );

        songAdmins.push(address(s_album));
        s_songs = createSongs(100);

        vm.warp(timeWarp);

        vm.startPrank(s_playlistOwner);
        s_playlist.ADD_SONGS_BATCH(s_songs);
        vm.stopPrank();

        s_albumPriceBasedOnCents = s_album.GET_PRICE_BASED_ON_CENTS();
    }

    function testMintAll(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(mintAmount >= s_albumPriceBasedOnCents);
        vm.assume(recipient != address(0));

        vm.deal(operator, mintAmount);

        vm.startPrank(operator);
        s_album.MINT_ALL{value: mintAmount}(recipient);
        vm.stopPrank();

        assertEq(s_album.balanceOf(recipient), 1);
        assertEq(s_album.tokenURI(0), goodURI);
        assertEq(s_album.ownerOf(0), recipient);
    }

    function testRevertMintAllNotEnoughEther(uint256 mintAmount) public {
        vm.assume(mintAmount < s_albumPriceBasedOnCents);

        vm.deal(address(0), mintAmount);

        vm.startPrank(address(0));
        vm.expectRevert(ALBUM.ALBUM__INVALID_MINT_NOT_ENOUGH_ETH.selector);
        s_album.MINT_ALL{value: mintAmount}(address(0));
        vm.stopPrank();
    }

    function testMintAllDoubleMint(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(mintAmount >= s_albumPriceBasedOnCents * 2);
        vm.assume(recipient != address(0));

        vm.deal(operator, mintAmount);

        vm.startPrank(operator);
        s_album.MINT_ALL{value: mintAmount / 2}(recipient);
        s_album.MINT_ALL{value: mintAmount / 2}(recipient);
        vm.stopPrank();

        assertEq(s_album.balanceOf(recipient), 1);
    }

    function testMintOnlyUnowned(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(recipient != address(0));
        vm.assume(mintAmount >= s_album.GET_UNOWNED_TOTAL_PRICE(recipient));

        vm.deal(operator, mintAmount);

        SONG song = SONG(s_songs[0]);
        uint256 songPrice = song.GET_PRICE();

        vm.startPrank(operator);
        song.MINT{value: songPrice}(recipient);
        s_album.MINT_ONLY_UNOWNED{value: mintAmount - songPrice}(recipient);
        vm.stopPrank();

        assertEq(s_album.balanceOf(recipient), 1);
    }

    function testRevertClaimIfDoesntOwnsAlbum(address recipient) public {
        vm.expectRevert(ALBUM.ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION.selector);
        s_album.CLAIM(recipient);
    }

    function testRevertClaimIfHasRedeemed(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(mintAmount >= s_albumPriceBasedOnCents);
        vm.assume(recipient != address(0));

        vm.deal(operator, mintAmount);

        vm.startPrank(operator);
        s_album.MINT_ALL{value: mintAmount}(recipient);
        vm.stopPrank();

        vm.expectRevert(ALBUM.ALBUM__ALREADY_CLAIMED.selector);
        s_album.CLAIM(recipient);
    }

    function testRevertTransferFrom(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(mintAmount >= s_albumPriceBasedOnCents);
        vm.assume(recipient != address(0));

        vm.deal(operator, mintAmount);

        vm.startPrank(operator);
        s_album.MINT_ALL{value: mintAmount}(recipient);
        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSelector(
                ALBUM.ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN.selector,
                recipient,
                operator,
                1
            )
        );
        s_album.transferFrom(recipient, operator, 1);
    }

    function testGetTotalPrice() public {
        uint256 totalSongsPrice = 0;
        for (uint256 i = 0; i < s_songs.length; i++) {
            totalSongsPrice += SONG(s_songs[i]).GET_PRICE();
        }

        assertEq(s_album.GET_TOTAL_PRICE_OF_SONGS(), totalSongsPrice);
    }

    function testGetGoodURI() public {
        assertEq(s_album.GET_GOOD_URI(), goodURI);
    }

    // function testGetBadURI() public {
    //     assertEq(s_album.GET_BAD_URI(), badURI);
    // }

    function testGetBadURI(
        address operator,
        address recipient,
        uint256 mintAmount
    ) public {
        vm.assume(mintAmount >= s_albumPriceBasedOnCents);
        vm.assume(recipient != address(0));
        vm.assume(recipient != operator);

        vm.deal(operator, mintAmount);

        vm.startPrank(operator);
        s_album.MINT_ALL{value: mintAmount}(recipient);
        vm.stopPrank();

        vm.startPrank(recipient);
        SONG(s_songs[0]).transferFrom(recipient, operator, 0);

        vm.stopPrank();

        assertEq(s_album.tokenURI(0), badURI);
        assertEq(s_album.balanceOf(recipient), 0);
        assertEq(s_album.ownerOf(0), address(0));
    }

    function createSong() public returns (address song) {
        SONG newSong = new SONG();

        newSong.initialize(
            s_songOwner,
            "Token",
            "T",
            "ipfs://Token",
            address(0),
            address(0),
            25,
            songAdmins,
            3600
        );

        song = address(newSong);
    }

    function createSongs(
        uint256 numToCreate
    ) public returns (address[] memory) {
        address[] memory songs = new address[](numToCreate);

        for (uint256 i = 0; i < songs.length; i++) {
            SONG newSong = new SONG();

            newSong.initialize(
                s_songOwner,
                string.concat("Token-", i.toString()),
                string.concat("T-", i.toString()),
                string.concat("ipfs://", i.toString()),
                address(s_dataAggregator),
                address(s_uptimeSequencer),
                25,
                songAdmins,
                3600
            );

            songs[i] = address(newSong);
        }

        return songs;
    }
}
