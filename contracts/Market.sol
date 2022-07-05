//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import '@openzeppelin/contracts/utils/Counters.sol';
//security against transactions for multiple requests
import 'hardhat/console.sol';

contract Market is ReentrancyGuard {
    using Counters for Counters.Counter;

    //number of itmes minting
    //keep track of tokens total number - token ID
    //arrays need to know the length

    Counters.Counter private _tokenIds;
    Counters.Counter private _tokensSold;
    
    //determine owner of contract
    //charge listing fee

    address payable owner;
    //listing price

    uint256 listingPrice = 0.0045 ether;

    constructor() {
        owner = payable(msg.sender);
    }
    struct MarketToken {
        uint itemID;
        address nftContract;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
    }

    //tokenId to return which market token - fetch

    mapping(uint256 => MarketToken) private idToMarketToken;
    
    // client side applications to listen events from front end

    event MarketTokenMinted(
        uint indexed itemId,
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uin256 price,
        bool sold
    );

    function getListingPrice() public view returns (uint256) {
        return listingPrice;
    }

    // two functions to interact with contract
    //1.create market item to put it up for sale
    //2. create market sale

    function mintMarketItem(
        address nftContract,
        uint tokenId,
        uint price
    )
    public payable nonReentrant {

    require(price > 0, 'Price must be at least one wei');
    require(msg.value == listingPrice, 'Pice must be equal to listing price'); 

    _tokenIds.increment();
    uint itemId = _tokenIds.current();   
    
    //put it up for sale
    idToMarketToken[itemId] = MarketToken(
        itemId,
        nftContract,
        tokenId,
        payable(msg.sender),
        payable(address(0)),
        price,
        false
    );
    
    //nft trnasactions


    }


}