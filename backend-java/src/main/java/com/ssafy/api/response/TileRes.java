package com.ssafy.api.response;

import java.time.LocalDateTime;
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
@ApiModel("TileResponse")
public class TileRes {
	@ApiModelProperty(name="타일 ID", example="KepC-A-001")
	String tid;
	
	@ApiModelProperty(name="면적", example="3000")
	int area;
	
	@ApiModelProperty(name="이미지", example="https://@@~~")
	String image;
	
	@ApiModelProperty(name="행성 아이디", example="2")
	long planet;
	
	@ApiModelProperty(name="최초 구매자 지갑 주소", example="account 1")
	String buyerId;
	
	@ApiModelProperty(name="최초 구매자 지갑 주소", example="0xB697444e418aeA6A4E7f23611f61a43Ab4761b5C")
	String buyerAdr;
	
	@ApiModelProperty(name="거래 일자", example="20150203")
	LocalDateTime tradeDate;
	
	@ApiModelProperty(name="가격", example="50")
	double price;
	
	@ApiModelProperty(name="token 아이디", example="0xB697444e418aeA6A4E7f23611f61a43Ab4761b5C")
	String tokenId;
	
	private static List<TileRes> tileAll = new ArrayList<>();
	
	public static TileRes of(Tile tile) {
		TileRes res = new TileRes();
		res.setTid(tile.getTid());
		res.setArea(tile.getArea());
		res.setBuyerAdr(tile.getBuyerAdr());
		res.setImage(tile.getImage());
		res.setPlanet(tile.getPlanet().getPid());
		res.setPrice(tile.getPrice());
		res.setTokenId(tile.getTokenId());
		res.setTradeDate(tile.getTradeDate());
		
		return res;
	}
	
	public static List<TileRes> of(List<Tile> tiles) {
		tileAll.clear();
		
		for(Tile t : tiles) {
			TileRes res = new TileRes();
			res.setTid(t.getTid());
			res.setArea(t.getArea());
			res.setBuyerAdr(t.getBuyerAdr());
			res.setImage(t.getImage());
			res.setPlanet(t.getPlanet().getPid());
			res.setPrice(t.getPrice());
			res.setTokenId(t.getTokenId());
			res.setTradeDate(t.getTradeDate());
			
			tileAll.add(res);
		}

		return tileAll;
	}
}