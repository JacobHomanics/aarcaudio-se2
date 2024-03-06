//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {PLAYLIST} from "./PLAYLIST.sol";
import {ALBUM} from "./ALBUM.sol";

interface IPartialERC721 {
    function balanceOf(address owner) external view returns (uint256 balance);
}

contract ALBUM_REDEMPTION is Ownable {
    error ALBUM_REDEMPTION__HAS_REDEEMED();
    error ALBUM_REDEMPTION__DOES_NOT_OWN_ENTIRE_COLLECTION();

    PLAYLIST S_PLAYLIST;
    ALBUM S_ALBUM;
    mapping(address user => bool) s_hasRedeemed;

    constructor(
        address OWNER,
        address NEW_PLAYLIST,
        address NEW_ALBUM
    ) Ownable(OWNER) {
        S_PLAYLIST = PLAYLIST(NEW_PLAYLIST);
        S_ALBUM = ALBUM(NEW_ALBUM);
    }

    function getHasRedeemed(
        address user
    ) public view returns (bool hasRedeemed) {
        hasRedeemed = s_hasRedeemed[user];
    }

    function MINT_IF_COMPLETE_OWNERSHIP(address TARGET) external {
        if (getHasRedeemed(TARGET)) revert ALBUM_REDEMPTION__HAS_REDEEMED();

        if (!CHECK_IF_OWNS_COLLECTION(TARGET))
            revert ALBUM_REDEMPTION__DOES_NOT_OWN_ENTIRE_COLLECTION();

        S_ALBUM.mint(TARGET);
    }

    function CHECK_IF_OWNS_COLLECTION(
        address TARGET
    ) public view returns (bool) {
        address[] memory songs = S_PLAYLIST.getAllSongs();
        uint256 ownedCount = 0;
        for (uint256 i = 0; i < songs.length; i++) {
            if (IPartialERC721(songs[i]).balanceOf(TARGET) > 0) {
                ownedCount++;
            }
        }

        return ownedCount == songs.length;
    }
}
