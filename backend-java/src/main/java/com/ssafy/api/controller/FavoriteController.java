package com.ssafy.api.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.api.request.FavoritePostReq;
import com.ssafy.api.response.FavoriteRes;
import com.ssafy.api.service.FavoriteService;
import com.ssafy.common.model.response.BaseResponseBody;
import com.ssafy.db.entity.Favorite;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "찜 API", tags = {"favorite"})
@CrossOrigin("*")
@RestController
public class FavoriteController {
	
	@Autowired
	FavoriteService favoriteService;

	@PostMapping("/favorite")
	@ApiOperation(value = "찜 목록 삽입", notes = "<strong>찜한</strong> 정보를 삽입시킨다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "삽입 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "삽입 실패", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> insertFavorite(@RequestBody @ApiParam(value="찜 삽입", required = true) FavoritePostReq favoriteInfo){
		
		if(favoriteService.insert(favoriteInfo)) {
			return ResponseEntity.status(200).body(BaseResponseBody.of(201, "Success"));
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Fail"));
		}
	}
	
	@GetMapping("/favorite/{walletId}")
	@ApiOperation(value = "찜 목록 조회", notes = "<strong>찜한</strong> 정보를 조회한다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "조회 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "조회 실패", response = BaseResponseBody.class)
    })
	public ResponseEntity<List<FavoriteRes>> findFavorite(@ApiParam(value="찜 조회", required = true)@PathVariable String walletId){
		
		List<Favorite> favorites = favoriteService.findByWalletId(walletId);
		
		return ResponseEntity.status(200).body(FavoriteRes.of(favorites));
	}
	
	@DeleteMapping("/favorite/{walletId}/{tileId}")
	@ApiOperation(value = "찜 목록 삭제", notes = "<strong>찜한</strong> 정보를 삭제시킨다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "삭제 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "삭제 실패", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> deleteFavorite(@ApiParam(value="찜 삭제", required = true)@PathVariable String walletId, @PathVariable String tileId){
		
		if(favoriteService.delete(walletId, tileId)) {
			return ResponseEntity.status(200).body(BaseResponseBody.of(201, "Success"));
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Fail"));
		}
	}
}
