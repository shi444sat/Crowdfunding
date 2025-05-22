const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contract with:", deployer.address);

  const goalInEther = "1"; // Set your goal (in ETH)
  const durationInMinutes = 60; // Set duration (e.g., 1 hour)

  const goalInWei = hre.ethers.utils.parseEther(goalInEther);

  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy(goalInWei, durationInMinutes);

  await crowdfunding.deployed();

  console.log(`✅ Contract deployed to: ${crowdfunding.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
