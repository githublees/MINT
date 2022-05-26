package com.ssafy.api.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssafy.api.request.FavoritePostReq;
import com.ssafy.db.entity.Favorite;
import com.ssafy.db.repository.FavoriteRepository;

@Service("FavoriteService")
public class FavoritServiceImpl implements FavoriteService{
	
	@Autowired
	FavoriteRepository favoriteRepository;
	
	@Override
	public boolean insert(FavoritePostReq favoriteInfo) {
		try {
			Favorite favorite = new Favorite();
			
			favorite.setWalletId(favoriteInfo.getWalletId());
			favorite.setTileId(favoriteInfo.getTileId());

			favoriteRepository.save(favorite);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return false;			
		}
		
		return true;
	}

	@Override
	public List<Favorite> findByWalletId(String wid) {
		
		return favoriteRepository.findByWalletId(wid);
	}

	@Override
	public boolean delete(String wid, String tid) {
		try {
			favoriteRepository.deleteByWalletIdAndTileId(wid, tid);
			
		} catch (Exception e) {
			System.out.println(e.getMessage());
			return false;
		}
		
		return true;
	}

}
