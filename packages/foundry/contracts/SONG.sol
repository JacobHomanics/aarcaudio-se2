//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SONG is Ownable, ERC721 {
    using Strings for uint256;

    error SONG__INVALID_MINT_NOT_ENOUGH_ETH();

    uint256 S_PRICE;
    string S_URI;
    uint256 S_MINT_COUNT;

    constructor(
        address OWNER,
        string memory NAME,
        string memory SYMBOL,
        uint256 PRICE,
        string memory URI
    ) Ownable(OWNER) ERC721(NAME, SYMBOL) {
        S_PRICE = PRICE;
        S_URI = URI;
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
}
