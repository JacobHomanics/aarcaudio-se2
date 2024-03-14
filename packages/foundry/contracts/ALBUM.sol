//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "forge-std/Test.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {PLAYLIST} from "./PLAYLIST.sol";
import {SONG} from "./SONG.sol";

import {AggregatorV2V3Interface} from "./chainlink/interfaces/AggregatorV2V3Interface.sol";

contract ALBUM is Ownable, ERC721 {
    error ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN(
        address FROM,
        address TO,
        uint256 TOKEN_ID
    );

    error ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION();
    error ALBUM__ALREADY_CLAIMED();
    error ALBUM__INVALID_MINT_NOT_ENOUGH_ETH();
    error ALBUM__SEQUENCER_DOWN();
    error ALBUM__GRACE_PERIOD_NOT_OVER();

    uint256 S_CENTS;

    PLAYLIST S_PLAYLIST;
    string S_GOOD_URI;
    string S_BAD_URI;
    uint256 S_MINT_COUNT;

    uint256 constant S_GRACE_PERIOD_TIME = 3600;

    AggregatorV2V3Interface S_DATA_FEED;
    AggregatorV2V3Interface S_SEQUENCER_UPTIME_FEED;

    mapping(address USER => bool) S_HAS_REDEEMED;

    constructor(
        address NEW_PLAYLIST,
        address OWNER,
        string memory NAME,
        string memory SYMBOL,
        string memory GOOD_URI,
        string memory BAD_URI,
        address DATA_FEED,
        address SEQUENCER_UPTIME_FEED,
        uint256 CENTS
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        S_CENTS = CENTS;

        S_GOOD_URI = GOOD_URI;
        S_BAD_URI = BAD_URI;
        S_PLAYLIST = PLAYLIST(NEW_PLAYLIST);

        S_DATA_FEED = AggregatorV2V3Interface(DATA_FEED);
        S_SEQUENCER_UPTIME_FEED = AggregatorV2V3Interface(
            SEQUENCER_UPTIME_FEED
        );
    }

    function WITHDRAW(address RECIPIENT) external onlyOwner {
        (bool SENT, ) = RECIPIENT.call{value: address(this).balance}("");
        require(SENT, "FAILED TO SEND ETHER");
    }

    function CLAIM(address TARGET) public {
        if (!CHECK_IF_OWNS_COLLECTION(TARGET))
            revert ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION();

        if (GET_HAS_REDEEMED(TARGET)) {
            revert ALBUM__ALREADY_CLAIMED();
        }
        _mint(TARGET, S_MINT_COUNT);
        S_HAS_REDEEMED[TARGET] = true;
        S_MINT_COUNT++;
    }

    function MINT_ONLY_UNOWNED(address TARGET) external payable {
        address[] memory SONGS = S_PLAYLIST.GET_ALL_SONGS();
        for (uint256 i = 0; i < SONGS.length; i++) {
            if (SONG(SONGS[i]).balanceOf(TARGET) == 0) {
                SONG(SONGS[i]).MINT{value: SONG(SONGS[i]).GET_PRICE()}(TARGET);
            }
        }

        CLAIM(TARGET);
    }

    function MINT_ALL(address TARGET) external payable {
        if (msg.value < GET_PRICE_BASED_ON_CENTS()) {
            revert ALBUM__INVALID_MINT_NOT_ENOUGH_ETH();
        }

        address[] memory SONGS = S_PLAYLIST.GET_ALL_SONGS();
        for (uint256 i = 0; i < SONGS.length; i++) {
            SONG(SONGS[i]).SPECIAL_MINT(TARGET);
        }

        if (!GET_HAS_REDEEMED(TARGET)) {
            CLAIM(TARGET);
        }
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN(from, to, tokenId);
    }

    function GET_HAS_REDEEMED(address user) public view returns (bool) {
        return S_HAS_REDEEMED[user];
    }

    function GET_OWNED_COUNT(address TARGET) public view returns (uint256) {
        address[] memory SONGS = S_PLAYLIST.GET_ALL_SONGS();
        uint256 OWNED_COUNT = 0;
        for (uint256 i = 0; i < SONGS.length; i++) {
            if (ERC721(SONGS[i]).balanceOf(TARGET) > 0) {
                OWNED_COUNT++;
            }
        }

        return OWNED_COUNT;
    }

    function CHECK_IF_OWNS_COLLECTION(
        address TARGET
    ) public view returns (bool) {
        return GET_OWNED_COUNT(TARGET) == S_PLAYLIST.GET_ALL_SONGS().length;
    }

    function GET_UNOWNED_TOTAL_PRICE(
        address TARGET
    ) external view returns (uint256) {
        uint256 TOTAL_COST = 0;
        address[] memory SONGS = S_PLAYLIST.GET_ALL_SONGS();

        for (uint256 i = 0; i < SONGS.length; i++) {
            if (SONG(SONGS[i]).balanceOf(TARGET) <= 0) {
                TOTAL_COST += SONG(SONGS[i]).GET_PRICE();
            }
        }

        return TOTAL_COST;
    }

    function GET_CENTS() public view returns (uint256) {
        return S_CENTS;
    }

    function GET_TOTAL_PRICE_OF_SONGS() external view returns (uint256) {
        uint256 TOTAL_COST = 0;
        address[] memory SONGS = S_PLAYLIST.GET_ALL_SONGS();

        for (uint256 i = 0; i < SONGS.length; i++) {
            TOTAL_COST += SONG(SONGS[i]).GET_PRICE();
        }

        return TOTAL_COST;
    }

    function GET_GOOD_URI() external view returns (string memory) {
        return S_GOOD_URI;
    }

    function GET_BAD_URI() external view returns (string memory) {
        return S_BAD_URI;
    }

    function GET_PRICE_BASED_ON_CENTS() public view returns (uint PRICE) {
        int RAW_PRICE = GET_CHAINLINK_DATA_FEED_LATEST_ANSWER();

        uint CURRENT_FIAT_PRICE = uint(RAW_PRICE) * 1e10;
        uint FIAT_PRICE = GET_CENTS() * 1e16;

        PRICE = (FIAT_PRICE * 1e18) / CURRENT_FIAT_PRICE;
    }

    function GET_CHAINLINK_DATA_FEED_LATEST_ANSWER() public view returns (int) {
        (, int256 ANSWER, uint256 STARTED_AT, , ) = S_SEQUENCER_UPTIME_FEED
            .latestRoundData();

        bool IS_SEQUENCER_UP = ANSWER == 0;
        if (!IS_SEQUENCER_UP) {
            revert ALBUM__SEQUENCER_DOWN();
        }

        uint256 TIME_SINCE_UP = block.timestamp - STARTED_AT;
        if (TIME_SINCE_UP <= S_GRACE_PERIOD_TIME) {
            revert ALBUM__GRACE_PERIOD_NOT_OVER();
        }

        (, int DATA, , , ) = S_DATA_FEED.latestRoundData();

        return DATA;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        if (!CHECK_IF_OWNS_COLLECTION(_ownerOf(tokenId))) {
            return S_BAD_URI;
        }

        return S_GOOD_URI;
    }

    function balanceOf(
        address owner
    ) public view virtual override returns (uint256) {
        if (!CHECK_IF_OWNS_COLLECTION(owner)) {
            return 0;
        }

        return super.balanceOf(owner);
    }

    function ownerOf(
        uint256 tokenId
    ) public view virtual override returns (address) {
        address owner = _ownerOf(tokenId);

        if (!CHECK_IF_OWNS_COLLECTION(owner)) {
            return address(0);
        }

        return _requireOwned(tokenId);
    }
}
