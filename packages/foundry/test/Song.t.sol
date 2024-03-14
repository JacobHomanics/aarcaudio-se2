// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {SONG} from "../contracts/SONG.sol";
import {PLAYLIST} from "../contracts/PLAYLIST.sol";
import {ALBUM} from "../contracts/ALBUM.sol";
import {MockAggregatorV2V3Interface} from "../contracts/chainlink/mocks/MockAggregatorV2V3Interface.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract SongTest is Test {
    using Strings for uint256;

    address s_owner;
    address s_admin;

    MockAggregatorV2V3Interface s_dataAggregator;
    MockAggregatorV2V3Interface s_uptimeSequencer;

    address[] songAdmins;

    SONG s_song;

    string ipfsUrl = "ipfs://1";
    int256 priceOfEthereum = 400000000000;
    uint256 cents = 25;
    uint256 priceBasedOnCents;
    uint256 timeWarp = 200000;

    function createDefaultSong() public {
        s_song = new SONG();

        s_song.initialize(
            s_owner,
            "Token",
            "T",
            ipfsUrl,
            address(s_dataAggregator),
            address(s_uptimeSequencer),
            cents,
            songAdmins,
            10
        );

        priceBasedOnCents = s_song.GET_PRICE_BASED_ON_CENTS();
    }

    function createLayer1Song() public {
        s_song = new SONG();

        s_song.initialize(
            s_owner,
            "Token",
            "T",
            ipfsUrl,
            address(s_dataAggregator),
            address(0),
            cents,
            songAdmins,
            10
        );

        priceBasedOnCents = s_song.GET_PRICE_BASED_ON_CENTS();
    }

    function setUp() public {
        s_owner = vm.addr(1);
        console.log("Owner: ", address(s_owner));
        s_admin = vm.addr(2);
        console.log("Admin: ", s_admin);

        s_dataAggregator = new MockAggregatorV2V3Interface(priceOfEthereum, 0);
        console.log("Mock Data Aggregator", address(s_dataAggregator));
        s_uptimeSequencer = new MockAggregatorV2V3Interface(0, 0);
        console.log("Mock Uptime Feed Sequencer", address(s_uptimeSequencer));

        songAdmins.push(s_admin);

        // s_song = new SONG(
        //     s_owner,
        //     "Token",
        //     "T",
        //     ipfsUrl,
        //     address(s_dataAggregator),
        //     address(s_uptimeSequencer),
        //     cents,
        //     songAdmins,
        //     10
        // );

        vm.warp(timeWarp);
    }

    function testCreateSong(uint256 uniqueId) public {
        createDefaultSong();

        SONG song = new SONG();

        song.initialize(
            s_owner,
            string.concat("Token-", uniqueId.toString()),
            string.concat("T-", uniqueId.toString()),
            string.concat("ipfs://", uniqueId.toString()),
            address(s_dataAggregator),
            address(s_uptimeSequencer),
            25,
            songAdmins,
            0
        );

        assertEq(song.owner(), s_owner);
        assertEq(song.name(), string.concat("Token-", uniqueId.toString()));
        assertEq(song.symbol(), string.concat("T-", uniqueId.toString()));
        assertEq(song.GET_URI(), string.concat("ipfs://", uniqueId.toString()));
        assertEq(song.GET_DATA_FEED(), address(s_dataAggregator));
        assertEq(song.GET_SEQUENCER_UPTIME_FEED(), address(s_uptimeSequencer));
        assertEq(song.GET_CENTS(), cents);
        assertEq(song.GET_GRACE_PERIOD_TIME(), 0);
        assertEq(song.GET_PRICE_BASED_ON_CENTS(), priceBasedOnCents);

        for (uint256 j = 0; j < songAdmins.length; j++) {
            assertEq(
                song.hasRole(song.DEFAULT_ADMIN_ROLE(), songAdmins[j]),
                true
            );
        }
    }

    function testMint(
        address minter,
        address recipient,
        uint256 mintAmount
    ) public {
        createDefaultSong();

        vm.assume(recipient != address(0));
        vm.assume(mintAmount >= priceBasedOnCents);

        vm.deal(minter, mintAmount);
        vm.startPrank(minter);
        s_song.MINT{value: mintAmount}(recipient);
        vm.stopPrank();
        assertEq(s_song.ownerOf(0), recipient);
        assertEq(s_song.balanceOf(recipient), 1);
        assertEq(s_song.tokenURI(0), ipfsUrl);
        assertEq(s_song.GET_MINT_COUNT(), 1);
        assertEq(minter.balance, 0);
        assertEq(address(s_song).balance, mintAmount);
    }

    function testRevertMintOnNotEnoughMintPrice(
        address minter,
        address recipient
    ) public {
        createDefaultSong();

        vm.assume(recipient != address(0));

        vm.deal(minter, 5);

        vm.startPrank(minter);
        vm.expectRevert(SONG.SONG__INVALID_MINT_NOT_ENOUGH_ETH.selector);
        s_song.MINT{value: 5}(recipient);
        vm.stopPrank();
    }

    function testRevertMintOnSequencerDown(
        address minter,
        address recipient,
        uint256 mintAmount
    ) public {
        createDefaultSong();

        vm.assume(recipient != address(0));
        vm.assume(mintAmount >= priceBasedOnCents);

        vm.deal(minter, mintAmount);

        s_uptimeSequencer.setAnswer(1);

        vm.startPrank(minter);
        vm.expectRevert(SONG.SONG__SEQUENCER_DOWN.selector);
        s_song.MINT{value: mintAmount}(recipient);
        vm.stopPrank();
    }

    function testRevertMintOnGracePeriodNotOver(
        address minter,
        address recipient,
        uint256 mintAmount
    ) public {
        createDefaultSong();

        vm.assume(recipient != address(0));
        vm.assume(mintAmount >= priceBasedOnCents);

        vm.deal(minter, mintAmount);

        s_uptimeSequencer.setStartedAt(timeWarp - 5);

        vm.startPrank(minter);
        vm.expectRevert(SONG.SONG__GRACE_PERIOD_NOT_OVER.selector);
        s_song.MINT{value: mintAmount}(recipient);
        vm.stopPrank();
    }

    function testSpecialMint(address recipient) public {
        createDefaultSong();

        vm.assume(recipient != address(0));

        vm.startPrank(s_admin);
        s_song.SPECIAL_MINT(recipient);
        vm.stopPrank();

        assertEq(s_song.ownerOf(0), recipient);
        assertEq(s_song.balanceOf(recipient), 1);
        assertEq(s_song.tokenURI(0), ipfsUrl);
    }

    function testWithdraw(address operator) public {
        createDefaultSong();

        vm.assume(operator != address(0));

        vm.deal(operator, priceBasedOnCents);
        vm.startPrank(operator);
        s_song.MINT{value: priceBasedOnCents}(operator);
        vm.stopPrank();

        vm.startPrank(s_owner);
        s_song.WITHDRAW(s_owner);
        vm.stopPrank();
        assertEq(address(s_song).balance, 0);
        assertEq(s_owner.balance, priceBasedOnCents);
    }
}
