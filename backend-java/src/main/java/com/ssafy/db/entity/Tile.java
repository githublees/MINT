package com.ssafy.db.entity;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * 타일 모델 정의.
 */
@Entity(name = "tile")
@Getter
@Setter
@NoArgsConstructor
public class Tile {

	@Id
    @Column(name = "tile_id")
    String tid;
	
	@ManyToOne
	@JoinColumn(name = "planet_id")
    Planet planet;
	
    String image;

    double price;
    
    @Column(name = "trade_date")
    @DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
    LocalDateTime tradeDate;
    
    @Column(name = "token_id")
    String tokenId;
    
    int area;
    
    @Column(name = "buyer_adr")
    String buyerAdr;
    
    public void setPlanet(Planet planet) {
    	this.planet = planet;
    	
    	if(!planet.getTiles().contains(this)) {
    		planet.getTiles().add(this);
    	}
    }
}
