package com.ssafy.api.response;

import java.util.ArrayList;
import java.util.List;

import com.ssafy.db.entity.Planet;
import com.ssafy.db.entity.Tile;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("PlanetSelectResponse")
public class PlanetSelectRes {

	@ApiModelProperty(name="포함된 셀 목록")
	List<TileRes> tiles = new ArrayList<>();
	
	public static PlanetSelectRes of(List<Tile> tile) {
		PlanetSelectRes res = new PlanetSelectRes();
		
		for(Tile t : tile) {
			res.addTile(t);
		}
		
		return res;
	}
	
	public void addTile(Tile tile) {
		TileRes tr = new TileRes();
		
		tr.setArea(tile.getArea());
		tr.setBuyerAdr(tile.getBuyerAdr());
		tr.setImage(tile.getImage());
		tr.setPlanet(tile.getPlanet().getPid());
		tr.setPrice(tile.getPrice());
		tr.setTid(tile.getTid());
		tr.setTokenId(tile.getTokenId());
		tr.setTradeDate(tile.getTradeDate());
		
		tiles.add(tr);
	}
}
