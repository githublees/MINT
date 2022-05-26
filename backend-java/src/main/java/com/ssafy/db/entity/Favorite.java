package com.ssafy.db.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity(name = "favorite")
@Getter
@Setter
@NoArgsConstructor
public class Favorite {

	@Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "favorite_id")
    Long fid;
	
	@Column(name = "wallet_id")
	String walletId;
	
	@Column(name = "tile_id")
	String tileId;
}
