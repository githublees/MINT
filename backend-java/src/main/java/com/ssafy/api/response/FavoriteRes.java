package com.ssafy.api.response;

import java.util.ArrayList;
import java.util.List;

import com.ssafy.db.entity.Favorite;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@ApiModel("FavoriteResponse")
public class FavoriteRes {
	
	@ApiModelProperty(name="타일 ID", example="KepC-A-001")
	String tileId;
	
	private static List<FavoriteRes> favorites = new ArrayList<>();
	
	public static List<FavoriteRes> of(List<Favorite> favorite) {
		favorites.clear();
		
		for(Favorite f : favorite) {
			FavoriteRes res = new FavoriteRes();
			
			res.setTileId(f.getTileId());
			
			favorites.add(res);
		}

		return favorites;
	}
}
