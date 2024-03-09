//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {PLAYLIST} from "./PLAYLIST.sol";

contract ALBUM is Ownable, AccessControl, ERC721 {
    error ALBUM__CANNOT_TRANSFER_SOULBOUND_TOKEN(
        address from,
        address to,
        uint256 tokenId
    );

    error ALBUM__DOES_NOT_OWN_ENTIRE_COLLECTION();
    error ALBUM__ALREADY_CLAIMED();

    string S_GOOD_URI;
    string S_BAD_URI;
    uint256 S_MINT_COUNT;

    PLAYLIST S_PLAYLIST;

    mapping(address user => bool) s_hasRedeemed;

    constructor(
        address NEW_PLAYLIST,
        address OWNER,
        address[] memory admins,
        string memory NAME,
        string memory SYMBOL,
        string memory GOOD_URI,
        string memory BAD_URI
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        for (uint256 i = 0; i < admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, admins[i]);
        }

        S_GOOD_URI = GOOD_URI;
        S_BAD_URI = BAD_URI;
        S_PLAYLIST = PLAYLIST(NEW_PLAYLIST);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);

        if (!CHECK_IF_OWNS_COLLECTION(ownerOf(tokenId))) {
            return S_BAD_URI;
        }

        return S_GOOD_URI;
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

    function claim(address TARGET) external {
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
}
