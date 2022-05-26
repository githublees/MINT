package com.ssafy.api.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.api.request.TilePutReq;
import com.ssafy.db.entity.Planet;
import com.ssafy.db.entity.Tile;
import com.ssafy.db.repository.PlanetRepository;
import com.ssafy.db.repository.TileRepository;

@Service("TileService")
public class TileServiceImpl implements TileService {
	
	@Autowired
	TileRepository tileRepository;
	
	@Autowired
	PlanetRepository planetRepository;
	
	@Override
	public List<Tile> getAllTiles() { // 모든 타일 조회
		return tileRepository.findAll();
	}

	@Override
	public Tile getTile(String tid) { // tid로 타일 조회
		return tileRepository.findByTid(tid).get();
	}

	@Override
	public boolean tileModify(TilePutReq tileInfo) { // tid로 타일 가져와서 수정
		try {
			Tile tile = getTile(tileInfo.getTid());
			
			Planet planet = planetRepository.findByPid(tileInfo.getPlanet()).get();
			
			tile.setArea(tileInfo.getArea());
			tile.setBuyerAdr(tileInfo.getBuyerAdr());
			tile.setPlanet(planet);
			tile.setPrice(tileInfo.getPrice());
			tile.setTokenId(tileInfo.getTokenId());
			
			LocalDateTime localDateTime = new java.sql.Timestamp(tileInfo.getTradeDate().getTime())
					.toLocalDateTime();
			
			tile.setTradeDate(localDateTime);
			
			tileRepository.save(tile);
		
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return false;
		}
		
		return true;
	}
}
