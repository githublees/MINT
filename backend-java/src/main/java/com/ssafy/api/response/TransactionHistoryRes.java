package com.ssafy.api.response;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ssafy.db.entity.Tile;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("TransactionHistoryResponse")
public class TransactionHistoryRes {
	
	@ApiModelProperty(name="거래내역")
	List<HistoryRes> historys = new ArrayList<>();
	
	public static TransactionHistoryRes of(List<Tile> tiles) {
		TransactionHistoryRes res = new TransactionHistoryRes();
		int number = 1;
		
		for(Tile t : tiles) {
			if(t.getTokenId() != null) {
				res.addHistory(number, t);
				number++;
			}
		}
		
		return res;
	}

	private void addHistory(int n, Tile t) {
		HistoryRes hr = new HistoryRes();
		
		hr.setId(n);
		hr.setBuyerAdr(t.getBuyerAdr());
		hr.setPrice(t.getPrice());
		hr.setName(t.getPlanet().getName());
		hr.setTradeDate(t.getTradeDate());
		
		historys.add(hr);
		
	}
}
