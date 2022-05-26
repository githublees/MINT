package com.ssafy.api.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.api.response.PlanetAllRes;
import com.ssafy.api.response.PlanetRes;
import com.ssafy.api.response.PlanetSelectRes;
import com.ssafy.api.response.TransactionHistoryRes;
import com.ssafy.api.service.PlanetService;
import com.ssafy.db.entity.Planet;
import com.ssafy.db.entity.Tile;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

@Api(value = "행성 API", tags = {"Planet"})
@CrossOrigin("*")
@RestController
public class PlanetController {
	
	@Autowired
	PlanetService planetService;
	
	@GetMapping("/planets")
	@ApiOperation(value = "전체 행성 조회", notes = "<strong행성</strong>전체 조회를 한다.")
	public ResponseEntity<PlanetAllRes> overall() {
		
		List<Planet> planets = planetService.getPlanets();

		return ResponseEntity.status(200).body(PlanetAllRes.of(planets));	
	}
	
	@GetMapping("/planet/{pid}")
	@ApiOperation(value = "행성 상세 조회", notes = "<strong>행성 id</strong>를 통해 상세 조회를 한다.")
	public ResponseEntity<PlanetRes> getPlanet(@ApiParam(value="행성 조회", required = true) @PathVariable Long pid) {
		
		Planet planet = planetService.getPlanet(pid);
		
		return ResponseEntity.status(200).body(PlanetRes.of(planet));
	}
	
	@GetMapping("/all/{pid}")
	@ApiOperation(value = "행성 별 전체 타일 조회", notes = "<strong행성 id</strong>를 통해 별 조회를 한다.")
	public ResponseEntity<PlanetSelectRes> search(@ApiParam(value="행성 조회", required = true) @PathVariable Long pid) {
		
		List<Tile> tiles = planetService.getTilesByPid(pid);

		return ResponseEntity.status(200).body(PlanetSelectRes.of(tiles));
	}
	
	@GetMapping("/remain/{pid}")
	@ApiOperation(value = "행성 별 남은 타일 조회", notes = "<strong행성 id</strong>를 통해 행성 별 남은 타일을 조회 한다.")
	public ResponseEntity<Integer> remain(
			@RequestBody @ApiParam(value="행성 여분 타일", required = true) @PathVariable Long pid) {
		
		int quantity = planetService.getRemainTile(pid);
		
		return ResponseEntity.status(200).body(quantity);
	}
	
	@GetMapping("/history")
	@ApiOperation(value = "거래내역 조회", notes = "<strong거래 내역</strong>을 출력한다.")
	public ResponseEntity<TransactionHistoryRes> history() {
		
		List<Tile> tiles = planetService.getAllTile();

		return ResponseEntity.status(200).body(TransactionHistoryRes.of(tiles));
	}
}
