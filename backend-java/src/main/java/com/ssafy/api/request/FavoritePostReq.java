package com.ssafy.api.request;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("FavoritePostRequest")
public class FavoritePostReq {
	
	@ApiModelProperty(name="지갑 아이디", example="0x0DIEKFMNC038DKDI")
	String walletId;
	
	@ApiModelProperty(name="행성 아이디", example="KFC-A-001")
	String tileId;
}
