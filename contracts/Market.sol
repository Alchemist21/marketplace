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
    IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);

    emit MarketTokenMinted(
        itemId,
        nftContract,
        tokenId,
        msg.sender,
        address(0),
        price,
        false
    );

    //function to conduct market sales
    function createMarketSale(
        address nftContract,
        uint itemId)
        public payable nonReentrant {
            uint price = idToMarketToken[itemId].price;
            uint tokenId = idToMarketToken[itemId].tokenId;
            require(msg.value == price, 'Please submit the asking price in order to continue')
       
            //transfer amount to seller
            idToMarketToken[itemId].seller.transfer(msg.value);
            //transfer token from contract address to the buyer
            IERC721(nftContract).transferFrom(address(this),msg.sender, tokenId);
            idToMarketToken[itemId].owner = payable(msg.sender);
            idToMarketToken[itemId].sold = true;
            _tokensSold.increment();

            payable(owner).transfer(listingPrice);
        }
    


    //function to fetch market items - minting/buying.selling
    //return number of unsold items

        function fetchMarketTokens() public view returns(MarketToken[] memory) {
            uint itemCount = _tokenIds.current();
            uint unsoldItemCount = _tokenIds.current() - _tokensSold.current();
            uint currentIndex = 0;

    //looping over number of items created

            MarketToken[] memory items = new MarketToken[](unsoldItemCount);
            for(uint i = 0; i < itemCount; i++){
                if(idToMarketToken[i + 1].owner == address(0)){
                    uint currentId = i + 1;
                    MarketToken storage currentItem = idToMarketToken[currentId];
                    items[currentIndex] = currentItem;
                    currentIndex += 1;

                }
            }
        return items;    
        }
        //return nfts that user has purchased

        function fetchMyNFTs() public view returns (MarketToken[] memory) {
            uint totalItemCount = _tokenIds.current();
            uint itemCount = 0;
            uint currentIndex = 0;

            for(uint i = 0; i< totalItemCount; i++) {
                if(idToMarketToken[i + 1].owner == msg.sender) {
                    itemCount += 1;
                }
            }
            //second to loop through the amount you have purchased 
            // check to see if owner address is equal to msg.sender

            MarketToken[] memory items = new MarketToken[](itemCount);
            for(uint i = 0; i < totalItemCount; i++) {
                uint currentId = idToMarketToken[i + 1].itemId;
                //current array
                MarketToken storage currentItem = idToMarketToken[currentId];
                items[currentIndex] = currentItem;
                currenIndex += 1;
            }
        }
        return items;

    }


}