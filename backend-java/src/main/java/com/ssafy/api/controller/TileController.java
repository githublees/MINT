package com.ssafy.api.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.api.request.TilePutReq;
import com.ssafy.api.response.TileRes;
import com.ssafy.api.service.TileService;
import com.ssafy.common.model.response.BaseResponseBody;
import com.ssafy.db.entity.Tile;
import com.ssafy.db.repository.TileRepository;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "Tile API")
@CrossOrigin("*")
@RestController
public class TileController {
	
	@Autowired
	TileService tileService;
	
	@Autowired
	TileRepository tileRepository;

	@GetMapping("/tiles")
	@ApiOperation(value = "전체 타일 조회", notes = "<strong>전체 타일</strong> 정보를 반환시킨다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "조회 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "조회 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "타일 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<List<TileRes>> getAllTiles(){
		
		List<Tile> tiles = tileService.getAllTiles();
		
		return ResponseEntity.status(200).body(TileRes.of(tiles));
	}
	
	@GetMapping("/tile/{tid}")
	@ApiOperation(value = "타일 조회", notes = "<strong>해당 타일</strong> 정보를 반환시킨다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "조회 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "조회 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "타일 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<TileRes> getTile(@PathVariable String tid){
		
		Tile tile = tileService.getTile(tid);
		
		return ResponseEntity.status(200).body(TileRes.of(tile));
	}
	
	
	@PutMapping("/tile")
	@ApiOperation(value = "타일 수정", notes = "<strong>해당 타일</strong>을 수정한다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "수정 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 400, message = "수정 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "타일 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> update(@RequestBody @ApiParam(value="타일 정보", required = true) TilePutReq tileInfo){
	
		if(tileService.tileModify(tileInfo)) {
			return ResponseEntity.status(200).body(BaseResponseBody.of(201, "Success"));
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Fail"));
		}
	}

}
