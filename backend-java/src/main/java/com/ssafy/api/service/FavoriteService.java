package com.ssafy.api.service;

import java.util.List;

import com.ssafy.api.request.FavoritePostReq;
import com.ssafy.db.entity.Favorite;

public interface FavoriteService {
	boolean insert(FavoritePostReq favoriteInfo);
	List<Favorite> findByWalletId(String wid);
	boolean delete(String wid, String tid);
}
