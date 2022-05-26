package com.ssafy.api.response;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.ssafy.db.entity.Tile;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("HistoryResponse")
public class HistoryRes {
	
	int id;
    String buyerAdr;
    double price;
    String name;
    LocalDateTime tradeDate;
}
