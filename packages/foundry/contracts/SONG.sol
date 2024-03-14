//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {AggregatorV2V3Interface} from "./chainlink/interfaces/AggregatorV2V3Interface.sol";

contract SONG is Ownable, AccessControl, ERC721 {
    using Strings for uint256;

    error SONG__INVALID_MINT_NOT_ENOUGH_ETH();
    error SONG__SEQUENCER_DOWN();
    error SONG__GRACE_PERIOD_NOT_OVER();
    error SONG__NOT_OWNER();
    string S_URI;
    uint256 S_MINT_COUNT;
    uint256 S_CENTS;

    AggregatorV2V3Interface S_DATA_FEED;
    AggregatorV2V3Interface S_SEQUENCER_UPTIME_FEED;
    uint256 S_GRACE_PERIOD_TIME;

    constructor(
        address OWNER,
        string memory NAME,
        string memory SYMBOL,
        string memory URI,
        address DATA_FEED,
        address SEQUENCER_UPTIME_FEED,
        uint256 CENTS,
        address[] memory ADMINS,
        uint256 GRACE_PERIOD_TIME
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        S_CENTS = CENTS;
        S_URI = URI;

        S_DATA_FEED = AggregatorV2V3Interface(DATA_FEED);
        S_SEQUENCER_UPTIME_FEED = AggregatorV2V3Interface(
            SEQUENCER_UPTIME_FEED
        );
        S_GRACE_PERIOD_TIME = GRACE_PERIOD_TIME;

        for (uint256 i = 0; i < ADMINS.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, ADMINS[i]);
        }
    }

    function WITHDRAW(address RECIPIENT) external onlyOwner {
        (bool SENT, ) = RECIPIENT.call{value: address(this).balance}("");
        if (!SENT) revert SONG__NOT_OWNER();
    }

    function MINT(address RECIPIENT) public payable {
        if (msg.value < GET_PRICE()) {
            revert SONG__INVALID_MINT_NOT_ENOUGH_ETH();
        }

        _mint(RECIPIENT, S_MINT_COUNT);
        S_MINT_COUNT++;
    }

    function SPECIAL_MINT(
        address RECIPIENT
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(RECIPIENT, S_MINT_COUNT);
        S_MINT_COUNT++;
    }

    function GET_MINT_COUNT() external view returns (uint256) {
        return S_MINT_COUNT;
    }

    function GET_PRICE() public view returns (uint256) {
        return GET_PRICE_BASED_ON_CENTS();
    }

    function GET_URI() external view returns (string memory) {
        return S_URI;
    }

    function GET_CENTS() public view returns (uint256) {
        return S_CENTS;
    }

    function GET_PRICE_BASED_ON_CENTS() public view returns (uint PRICE) {
        int RAW_PRICE = GET_CHAINLINK_DATA_FEED_LATEST_ANSWER();

        uint CURRENT_FIAT_PRICE = uint(RAW_PRICE) * 1e10;
        uint FIAT_PRICE = GET_CENTS() * 1e16;

        PRICE = (FIAT_PRICE * 1e18) / CURRENT_FIAT_PRICE;
    }

    function GET_CHAINLINK_DATA_FEED_LATEST_ANSWER() public view returns (int) {
        if (address(S_SEQUENCER_UPTIME_FEED) != address(0)) {
            (, int256 ANSWER, uint256 STARTED_AT, , ) = S_SEQUENCER_UPTIME_FEED
                .latestRoundData();

            bool IS_SEQUENCER_UP = ANSWER == 0;
            if (!IS_SEQUENCER_UP) {
                revert SONG__SEQUENCER_DOWN();
            }

            uint256 TIME_SINCE_UP = block.timestamp - STARTED_AT;
            if (TIME_SINCE_UP <= S_GRACE_PERIOD_TIME) {
                revert SONG__GRACE_PERIOD_NOT_OVER();
            }
        }

        (, int DATA, , , ) = S_DATA_FEED.latestRoundData();

        return DATA;
    }

    function GET_DATA_FEED() external view returns (address DATA_FEED) {
        DATA_FEED = address(S_DATA_FEED);
    }

    function GET_SEQUENCER_UPTIME_FEED()
        external
        view
        returns (address SEQUENCER_UPTIME_FEED)
    {
        SEQUENCER_UPTIME_FEED = address(S_SEQUENCER_UPTIME_FEED);
    }

    function GET_GRACE_PERIOD_TIME() external view returns (uint256) {
        return S_GRACE_PERIOD_TIME;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);
        return S_URI;
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
