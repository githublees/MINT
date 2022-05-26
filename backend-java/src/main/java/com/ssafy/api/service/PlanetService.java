package com.ssafy.api.service;

import java.util.List;

import com.ssafy.db.entity.Planet;
import com.ssafy.db.entity.Tile;

/**
 *	행성 관련 API Service
 */
public interface PlanetService {
	List<Tile> getTilesByPid(Long pid);
	int getRemainTile(Long pid);
	Planet getPlanet(Long pid);
	List<Planet> getPlanets();
	List<Tile> getAllTile();
}
