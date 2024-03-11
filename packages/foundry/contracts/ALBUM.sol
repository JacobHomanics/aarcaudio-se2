//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {PLAYLIST} from "./PLAYLIST.sol";
import {SONG} from "./SONG.sol";

import {AggregatorV2V3Interface} from "./chainlink/interfaces/AggregatorV2V3Interface.sol";

contract ALBUM is Ownable, AccessControl, ERC721 {
    error ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN(
        address from,
        address to,
        uint256 tokenId
    );

    error ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION();
    error ALBUM__ALREADY_CLAIMED();
    error ALBUM__INVALID_MINT_NOT_ENOUGH_ETH();

    string S_GOOD_URI;
    string S_BAD_URI;
    uint256 S_MINT_COUNT;

    PLAYLIST S_PLAYLIST;

    uint256 S_CENTS;
    AggregatorV2V3Interface internal s_dataFeed;

    mapping(address user => bool) s_hasRedeemed;

    function GET_CENTS() public view returns (uint256) {
        return S_CENTS;
    }

    constructor(
        address NEW_PLAYLIST,
        address OWNER,
        address[] memory admins,
        string memory NAME,
        string memory SYMBOL,
        string memory GOOD_URI,
        string memory BAD_URI,
        address dataFeed,
        uint256 cents
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        for (uint256 i = 0; i < admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, admins[i]);
        }

        S_CENTS = cents;

        s_dataFeed = AggregatorV2V3Interface(dataFeed);

        S_GOOD_URI = GOOD_URI;
        S_BAD_URI = BAD_URI;
        S_PLAYLIST = PLAYLIST(NEW_PLAYLIST);
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

    function WITHDRAW(address RECIPIENT) external onlyOwner {
        (bool SENT, ) = RECIPIENT.call{value: address(this).balance}("");
        require(SENT, "FAILED TO SEND ETHER");
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
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

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        revert ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN(from, to, tokenId);
    }

    function getHasRedeemed(
        address user
    ) public view returns (bool hasRedeemed) {
        hasRedeemed = s_hasRedeemed[user];
    }

    function CHECK_IF_OWNS_COLLECTION(
        address TARGET
    ) public view returns (bool) {
        address[] memory songs = S_PLAYLIST.getAllSongs();
        uint256 ownedCount = 0;
        for (uint256 i = 0; i < songs.length; i++) {
            if (ERC721(songs[i]).balanceOf(TARGET) > 0) {
                ownedCount++;
            }
        }

        return ownedCount == songs.length;
    }

    function MINT_ONLY_UNOWNED(address TARGET) external payable {
        address[] memory songs = S_PLAYLIST.getAllSongs();
        for (uint256 i = 0; i < songs.length; i++) {
            if (SONG(songs[i]).balanceOf(TARGET) <= 0) {
                SONG(songs[i]).MINT{value: SONG(songs[i]).getPrice()}(TARGET);
            }
        }

        claim(TARGET);
    }

    function MINT_ALL(address TARGET) external payable {
        if (msg.value < getMintPriceBasedOnCents()) {
            revert ALBUM__INVALID_MINT_NOT_ENOUGH_ETH();
        }

        address[] memory songs = S_PLAYLIST.getAllSongs();
        for (uint256 i = 0; i < songs.length; i++) {
            SONG(songs[i]).SPECIAL_MINT(TARGET);
        }

        claim(TARGET);
    }

    function getUnownedTotalPrice(
        address TARGET
    ) external view returns (uint256) {
        uint256 totalCost = 0;
        address[] memory songs = S_PLAYLIST.getAllSongs();

        for (uint256 i = 0; i < songs.length; i++) {
            if (SONG(songs[i]).balanceOf(TARGET) <= 0) {
                totalCost += SONG(songs[i]).getPrice();
            }
        }

        return totalCost;
    }

    function getTotalPrice() external view returns (uint256) {
        uint256 totalCost = 0;
        address[] memory songs = S_PLAYLIST.getAllSongs();

        for (uint256 i = 0; i < songs.length; i++) {
            totalCost += SONG(songs[i]).getPrice();
        }

        return totalCost;
    }

    function claim(address TARGET) public {
        if (!CHECK_IF_OWNS_COLLECTION(TARGET))
            revert ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION();

        if (getHasRedeemed(TARGET)) {
            revert ALBUM__ALREADY_CLAIMED();
        }
        _mint(TARGET, S_MINT_COUNT);
        s_hasRedeemed[TARGET] = true;
        S_MINT_COUNT++;
    }

    function getGoodURI() external view returns (string memory) {
        return S_GOOD_URI;
    }

    function getBadURI() external view returns (string memory) {
        return S_BAD_URI;
    }

    function getMintPriceBasedOnCents() public view returns (uint) {
        int price = getChainlinkDataFeedLatestAnswer();

        // uint currentFiatPrice = 77697017 * 1e10;
        uint currentFiatPrice = uint(price) * 1e10;
        uint fiatPrice = GET_CENTS() * 1e16;

        uint value = (fiatPrice * 1e18) / currentFiatPrice;
        return value;
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
