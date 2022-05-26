package com.ssafy.api.response;

import com.ssafy.db.entity.Planet;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("PlanetResponse")
public class PlanetRes{
	
	Long pid;
	String name;
	double diameter;
	double mass;
	String galaxy;
	String content;
    int totalCell;
    
	public static PlanetRes of(Planet planet) {
		PlanetRes res = new PlanetRes();
		res.setPid(planet.getPid());
		res.setName(planet.getName());
		res.setDiameter(planet.getDiameter());
		res.setMass(planet.getMass());
		res.setGalaxy(planet.getGalaxy());
		res.setContent(planet.getContent());
		res.setTotalCell(planet.getTotalCell());
		
		return res;
	}
}
