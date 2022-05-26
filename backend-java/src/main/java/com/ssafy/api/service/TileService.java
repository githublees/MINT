package com.ssafy.api.service;

import java.util.List;

import com.ssafy.api.request.TilePutReq;
import com.ssafy.db.entity.Tile;

public interface TileService {
	List<Tile> getAllTiles();
	Tile getTile(String tid);
	boolean tileModify(TilePutReq tileInfo);
}
