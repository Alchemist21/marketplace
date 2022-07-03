require("@nomiclabs/hardhat-waffle");


module.exports = {
  defaultNetwork: 'hardhat',
  networks:{
    hardhat:{
      chainId: 1337 //config standard
    },
    kovan:{
      url: 'https://kovan.infura.io/v3/95238e7b44f44cec8308c00171c469e2',
    }
  }
  solidity: "0.8.4",
};
