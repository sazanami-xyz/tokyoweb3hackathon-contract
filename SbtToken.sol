// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract SbtToken is ERC721, Ownable, EIP712, ERC721Votes {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;

    string baseURI;
    uint256 public maxSupply = 54;
    uint256 public maxMintAmount = 1;
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) EIP712(_name, "1") {
        baseURI = _initBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= maxSupply);
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721)
    {
        require(from == address(0), "Err: token is SOUL BOUND");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) 
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for noneexistent token");
        string memory currentBaseUri = _baseURI();
        return bytes(currentBaseUri).length > 0 
        ? string(abi.encodePacked(currentBaseUri, tokenId.toString(), ".json"))
        : "";
    }

}
