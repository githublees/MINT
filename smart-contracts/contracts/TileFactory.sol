// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./TileNFT.sol";

contract TileFactory is TileNFT {
    uint256 public tileIds;
    address payable owner;

    constructor(address payable _ownerAddress) {
        owner = _ownerAddress;
    }

    struct Tile {
        uint256 tileId;
        address payable tileOwner;
        string galaxyName;
        string planetName;
        string tileName;
        uint256 price;
        string issuer;
        bool assurance;
    }

    mapping(uint256 => Tile) tileInfo;
    mapping(uint256 => uint256) tempPrice;

    event nftPurchase(
        uint256 indexed tileId,
        address indexed buyer,
        uint256 price,
        uint256 indexed purchaseTime
    );

    function currentTileId() public view returns (uint256) {
        return tileIds;
    }

    function createAndBuy(
        string memory _galaxyName,
        string memory _planetName,
        string memory _tileName,
        uint256 _price
    ) public payable {
        require(
            msg.sender != address(0),
            "The caller must not have an address of 0."
        );
        require(!_exists(tileIds + 1), "already exists token");

        require(
            owner != address(0),
            "CurrentOwner must not have an address of 0."
        );
        require(owner != msg.sender, "TileOwner should not be a caller.");

        require(
            msg.value >= _price,
            "price sent in to buy should be equal to or more than the token's price"
        );

        //토큰 전송 및 지불
        owner.transfer(msg.value);

        tileIds++;

        //토큰 발행
        mint(tileIds);

        Tile memory newTile = Tile(
            tileIds,
            payable(msg.sender),
            _galaxyName,
            _planetName,
            _tileName,
            msg.value,
            "MINT",
            true
        );

        tileInfo[tileIds] = newTile;

        emit nftPurchase(tileIds, msg.sender, _price, block.timestamp);
    }

    function sell(uint256 _price, uint256 _tileId) public {
        require(
            msg.sender != address(0),
            "The caller must not have an address of 0."
        );
        require(_exists(_tileId), "This token does not exist.");

        require(
            owner != address(0),
            "CurrentOwner must not have an address of 0."
        );
        require(
            tileInfo[_tileId].assurance,
            "This is an already registered token."
        );

        setApprovalForAll(address(this), true);

        tempPrice[_tileId] = _price;
        tileInfo[_tileId].assurance = false;
    }

    function buy(uint256 _tileId) public payable {
        require(
            msg.sender != address(0),
            "The caller must not have an address of 0."
        );
        require(_exists(_tileId), "This token does not exist.");

        require(
            owner != address(0),
            "CurrentOwner must not have an address of 0."
        );
        require(
            msg.value >= tempPrice[_tileId],
            "price sent in to buy should be equal to or more than the token's price"
        );
        require(tileInfo[_tileId].tileOwner != msg.sender, "can't call seller");
        require(!tileInfo[_tileId].assurance, "Not registered for sale.");

        tileInfo[_tileId].tileOwner.transfer(msg.value);

        IERC721(address(this)).transferFrom(
            tileInfo[_tileId].tileOwner,
            msg.sender,
            _tileId
        );

        tileInfo[_tileId].tileOwner = payable(msg.sender);
        tileInfo[_tileId].price = tempPrice[_tileId];
        tileInfo[_tileId].assurance = true;

        emit nftPurchase(
            _tileId,
            msg.sender,
            tempPrice[_tileId],
            block.timestamp
        );
    }

    function cancel(uint256 _tileId) public {
        require(
            msg.sender != address(0),
            "The caller must not have an address of 0."
        );
        require(_exists(_tileId), "This token does not exist.");

        require(
            owner != address(0),
            "CurrentOwner must not have an address of 0."
        );

        require(tileInfo[_tileId].tileOwner == msg.sender, "not tileOwner");

        setApprovalForAll(address(this), false);

        tileInfo[_tileId].assurance = true;
    }

    function getAllTile() public view returns (Tile[] memory) {
        uint256 idx = 0;

        Tile[] memory result = new Tile[](tileIds);
        for (uint256 i = 1; i <= tileIds; i++) {
            result[idx] = tileInfo[i];
            idx += 1;
        }

        return result;
    }

    function getMyTile() public view returns (Tile[] memory) {
        uint256 totalIds = 0;
        uint256 idx = 0;

        for (uint256 i = 1; i <= tileIds; i++) {
            if (tileInfo[i].tileOwner == msg.sender) {
                totalIds += 1;
            }
        }

        Tile[] memory result = new Tile[](totalIds);
        for (uint256 i = 1; i <= tileIds; i++) {
            if (tileInfo[i].tileOwner == msg.sender) {
                result[idx] = tileInfo[i];
                idx += 1;
            }
        }

        return result;
    }

    function getTileId(uint256 _tileId) public view returns (Tile memory) {
        if (tileInfo[_tileId].assurance) {
            return tileInfo[_tileId];
        } else {
            Tile memory result = Tile(
                tileInfo[_tileId].tileId,
                tileInfo[_tileId].tileOwner,
                tileInfo[_tileId].galaxyName,
                tileInfo[_tileId].planetName,
                tileInfo[_tileId].tileName,
                tempPrice[_tileId],
                tileInfo[_tileId].issuer,
                tileInfo[_tileId].assurance
            );

            return result;
        }
    }
}
