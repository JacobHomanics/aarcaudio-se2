//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import {AggregatorV2V3Interface} from "./chainlink/interfaces/AggregatorV2V3Interface.sol";

contract SONG is Ownable, ERC721 {
    using Strings for uint256;

    error SONG__INVALID_MINT_NOT_ENOUGH_ETH();

    uint256 S_PRICE;
    string S_URI;
    uint256 S_MINT_COUNT;

    AggregatorV2V3Interface internal s_dataFeed;

    // AggregatorV2V3Interface internal sequencerUptimeFeed;

    // uint256 private constant GRACE_PERIOD_TIME = 3600;

    // error SequencerDown();
    // error GracePeriodNotOver();

    function getPrice() external view returns (uint256) {
        return S_PRICE;
    }

    function getURI() external view returns (string memory) {
        return S_URI;
    }

    constructor(
        address OWNER,
        string memory NAME,
        string memory SYMBOL,
        uint256 PRICE,
        string memory URI,
        address dataFeed
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        S_PRICE = PRICE;
        S_URI = URI;

        s_dataFeed = AggregatorV2V3Interface(dataFeed);
        // sequencerUptimeFeed = AggregatorV2V3Interface(
        //     0xBCF85224fc0756B9Fa45aA7892530B47e10b6433 //base MAINNET
        // );
    }

    function WITHDRAW(address RECIPIENT) external onlyOwner {
        (bool SENT, ) = RECIPIENT.call{value: address(this).balance}("");
        require(SENT, "FAILED TO SEND ETHER");
    }

    function MINT(address RECIPIENT) public payable {
        if (msg.value < S_PRICE) {
            revert SONG__INVALID_MINT_NOT_ENOUGH_ETH();
        }

        _mint(RECIPIENT, S_MINT_COUNT);
        S_MINT_COUNT++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);
        return S_URI;
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        // (
        //     /*uint80 roundID*/,
        //     int256 answer,
        //     uint256 startedAt,
        //     /*uint256 updatedAt*/,
        //     /*uint80 answeredInRound*/
        // ) = sequencerUptimeFeed.latestRoundData();

        // // Answer == 0: Sequencer is up
        // // Answer == 1: Sequencer is down
        // bool isSequencerUp = answer == 0;
        // if (!isSequencerUp) {
        //     revert SequencerDown();
        // }

        // // Make sure the grace period has passed after the
        // // sequencer is back up.
        // uint256 timeSinceUp = block.timestamp - startedAt;
        // if (timeSinceUp <= GRACE_PERIOD_TIME) {
        //     revert GracePeriodNotOver();
        // }

        // prettier-ignore
        (
            /*uint80 roundID*/,
            int data,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = s_dataFeed.latestRoundData();

        return data;
    }
}
