package com.ssafy.db.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.ssafy.db.entity.Planet;

/**
 * 유저 모델 관련 디비 쿼리 생성을 위한 JPA Query Method 인터페이스 정의.
 */
@Repository
public interface PlanetRepository extends JpaRepository<Planet, Long> {
    Optional<Planet> findByPid(Long pid);
    List<Planet> findAll();
	Optional<Planet> findByName(String name);
}