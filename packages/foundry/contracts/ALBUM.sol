//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract ALBUM is Ownable, AccessControl, ERC721 {
    string S_URI;
    uint256 S_MINT_COUNT;

    constructor(
        address OWNER,
        address[] memory admins,
        string memory NAME,
        string memory SYMBOL,
        string memory URI
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        for (uint256 i = 0; i < admins.length; i++) {
            _grantRole(DEFAULT_ADMIN_ROLE, admins[i]);
        }

        S_URI = URI;
    }

    function mint(address TARGET) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _mint(TARGET, S_MINT_COUNT);
        S_MINT_COUNT++;
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
