// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./token/ERC721/ERC721.sol";

contract TileNFT is ERC721 {
    constructor() ERC721("LAND", "LD") {}

    function mint(uint256 _tokenId) public {
        uint256 tokenIds = _tokenId;
        _safeMint(msg.sender, tokenIds);
    }

    function burn(uint256 _tokenId) public {
        _burn(_tokenId);
    }
}
