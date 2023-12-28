# How to Make NFTs with On-Chain Metadata

In this project we created dynamic, fully on-chain NFTs using SVG and base64 encoding. This of course loads the contract's storage more heavily than if IPFS is used, which is why we deployed this on Polygon, instead of Ethereum. You can find the full walkthrough [here](https://docs.alchemy.com/docs/how-to-make-nfts-with-on-chain-metadata-hardhat-and-javascript), although some things are deprecated, take a look at the code in this repo for an updated version.

The NFTs represented the level of a warrior, which was upgradeable by means of a train function that increased the level. Also, we took the challenge to make the warrior NFTs have three pseudorandom stats and tested thiw new functionality with a Hardhat script.

We deployed and verified the NFT contract [here](https://mumbai.polygonscan.com/address/0xC2CD081Db4b0a56af9A976789f0fCe1aCD0aB613), and then minted and trained an NFT, which worked as expected, as we could see on OpenSea:

## Minted NFT
![image](https://github.com/arynyestos/RoadToWeb3NftsOnchainMetadata/assets/33223441/0cdf087b-6fbe-49dd-9bf0-9225b362f7bf)

## NFT trained to level 2
![image](https://github.com/arynyestos/RoadToWeb3NftsOnchainMetadata/assets/33223441/d2467089-5144-44e7-816c-5e1c77e11593)

