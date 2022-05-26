const TileNFT = artifacts.require("TileNFT");
const TileFactory = artifacts.require("TileFactory");

module.exports = function (deployer) {
  deployer.deploy(TileNFT);
  deployer.deploy(TileFactory);
};
