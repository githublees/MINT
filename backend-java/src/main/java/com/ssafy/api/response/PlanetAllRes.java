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
@ApiModel("PlanetAllResponse")
public class PlanetAllRes {

	@ApiModelProperty(name="전체 행성")
	List<PlanetRes> planet = new ArrayList<>();
	
	public static PlanetAllRes of(List<Planet> planets) {
		PlanetAllRes res = new PlanetAllRes();
		
		for(Planet p : planets) {
			res.addPlanet(p);
		}
		
		return res;
	}

	private void addPlanet(Planet p) {
		PlanetRes pr = new PlanetRes();
		
		pr.setPid(p.getPid());
		pr.setName(p.getName());
		pr.setGalaxy(p.getGalaxy());
		pr.setDiameter(p.getDiameter());
		pr.setMass(p.getMass());
		pr.setContent(p.getContent());
		pr.setTotalCell(p.getTotalCell());
		
		planet.add(pr);
		
	}
}
