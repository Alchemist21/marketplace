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
    constructor(address marketplaceAddress) ERC721('Newyorknft', 'NYC') {
        contractAddress = marketplaceAddress;
    }
}