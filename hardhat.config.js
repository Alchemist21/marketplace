require("@nomiclabs/hardhat-waffle");
const projectId = '95238e7b44f44cec8308c00171c469e2'
const fs = require('fs')
const keyData = fs.readFileSync('./p-key.txt', {
  encoding: 'utf8', flag:'r'
})

module.exports = {
  defaultNetwork: 'hardhat',
  networks:{
    hardhat:{
      chainId: 1337 //config standard
    },
    kovan:{
      url: `https://kovan.infura.io/v3/`${projectId},
      accounts:[keyData]
    },
    mainnet: {
      url: `https://mainnet.infura.io/v3/`${projectId},
      accounts:[keyData]
    }
  },
  solidity: {
    version: "0.8.4",
    settings: {
      optimizer: {
        enables: true,
        runs: 200
      }
    }
  }
};
