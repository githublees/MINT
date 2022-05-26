const TileFactory = artifacts.require("TileFactory");
let mintTokenContract, tileFactoryContract, nftContract;

contract("Smart-Contract Testing", (accounts) => {

    beforeEach(async () => {
        tileFactoryContract = await TileFactory.deployed();
    })

    describe("minting test", async () => {
        it("creates a new nft", async () => {
            
            await tileFactoryContract.create(1, "galaxy", "planet", "MINT", web3.utils.toWei("1", "Ether"), {from: accounts[0]});
            await tileFactoryContract.create(2, "galaxy", "planet", "MINT", web3.utils.toWei("1", "Ether"), {from: accounts[0]});
            
            await tileFactoryContract.buy(1, { from: accounts[1], value: web3.utils.toWei("1", "Ether") });

            let tiles = await tileFactoryContract.getAllTile();
            let tile = await tileFactoryContract.getMyTile({from: accounts[1]});
            let tie = await tileFactoryContract.getTileId(2);

            console.log(tiles[0].tileId);
            console.log(tile);
            console.log(tie);
            //assert.equal(tile.tileOwner, address(this), "tileOwner is faild");
        })
    })
})