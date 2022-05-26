package com.ssafy.db.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.db.entity.Tile;

@Repository
public interface TileRepository extends JpaRepository<Tile, String>{
	//tid로 Tile entity 가져오기
	Optional<Tile> findByTid(String tid);
	
	//pid로 Tile 레코드 갯수 세기
	int countByPlanetPidAndTokenIdIsNull(Long pid);
}
