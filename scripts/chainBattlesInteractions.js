const { ethers } = require("hardhat");

async function printStats(owner, chainBattlesImproved, tokenId) {
  let [level, hitpoints, strength, speed] = await chainBattlesImproved.connect(owner).getStats(tokenId)
  console.log(`Stats of NFT with token ID ${tokenId}: 
      - Level: ${level},
      - Hitpoints: ${hitpoints},
      - Strength: ${strength},
      - Speed: ${speed}`
  );
}

async function main() {

  // Get the example accounts we'll be working with.
  const [owner, account2] = await ethers.getSigners();

  // We get the contract to deploy and deploy it.
  const ChainBattlesImproved = await ethers.getContractFactory("ChainBattlesImproved");
  const chainBattlesImproved = await ChainBattlesImproved.deploy();
  await chainBattlesImproved.waitForDeployment();
  console.log("ChainBattlesImproved deployed to:", chainBattlesImproved.target);

  // Mint NFTs with two different accounts
  await chainBattlesImproved.connect(owner).mint();
  await chainBattlesImproved.connect(account2).mint();

  // Check NFT stats after minting
  console.log("Stats after minting:")
  await printStats(owner, chainBattlesImproved, 0);
  await printStats(owner, chainBattlesImproved, 1);

  // Train NFTs
  await chainBattlesImproved.connect(owner).train(0);
  await chainBattlesImproved.connect(account2).train(1);

  // Check NFT stats after training
  console.log("Stats after training:")
  await printStats(owner, chainBattlesImproved, 0);
  await printStats(owner, chainBattlesImproved, 1);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });