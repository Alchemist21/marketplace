//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//openzeppelin ERC 721 for minting

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStirage.sol';
import '@openzeppelin/contracts/utils/Counters.sol';

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // counters allow us to track token Ids
    //address for marketplace for NFts to interact
    address contractAddress;

    //NFT Market to transact
    //set approval for all allows to change ownership

    //constructor
    constructor(address marketplaceAddress) ERC721('Newyork', 'NYC') {
        contractAddress = marketplaceAddress;
    }

    function mintToken(string memory tokenURI) public returns(uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        //set token URI : id and url
        _setTokenURI(newItemId, tokenURI);
        //give marketplace the approval to transact between users
        setApprovalForAll(contractAddress, true);
        //mint token and set it for sale
        return newItemId;
    }
}