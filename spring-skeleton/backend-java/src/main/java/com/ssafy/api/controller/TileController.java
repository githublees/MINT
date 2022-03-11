package com.ssafy.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ssafy.api.request.TilePutReq;
import com.ssafy.api.service.PlanetService;
import com.ssafy.api.service.TileService;
import com.ssafy.common.model.response.BaseResponseBody;
import com.ssafy.db.entity.Planet;
import com.ssafy.db.entity.Tile;
import com.ssafy.db.repository.TileRepository;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "회의 API", tags = {"Conference."})
@RestController
@RequestMapping("/conference")
public class TileController {
	
	@Autowired
	TileService conferenceService;
	
	@Autowired
	TileRepository conferenceRepository;
	
	@Autowired
	PlanetService userService;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@GetMapping("/create/{userId}")
	@ApiOperation(value = "방 생성", notes = "<strong>유저 ID</strong>를 주소로 방을 생성한다.") 
    @ApiResponses({
        @ApiResponse(code = 401, message = "인증 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "사용자 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> create(@PathVariable String userId) {

		Tile user = userService.getUserByUserId(userId);
		
		if(!conferenceService.checkConferenceDuplicate(user.getUid())){
			Planet conference = conferenceService.create(user);
			
			return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Success"));
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Faild"));
		}
	}
	
	@GetMapping("/join/{userId}/{uid}")
	@ApiOperation(value = "방 입장", notes = "<strong>해당 oid 방에</strong>참가한다.") 
    @ApiResponses({
        @ApiResponse(code = 401, message = "방 비활성화 상태", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "사용자 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> join(@PathVariable String userId, @PathVariable Long uid){
		
		Tile user = userService.getUserByUserId(userId);
		Planet conference = conferenceService.conferenceAddUser(user.getUid(), uid);
		
		if(user.getUid() == uid) {
			return ResponseEntity.status(201).body(BaseResponseBody.of(201, "Host participation"));			
		}else if(conference.isActive()){
			return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Guest participation"));						
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Conference disabled"));				
		}
	}
	
	@GetMapping("/leave/{userId}/{uid}")
	@ApiOperation(value = "방 종료", notes = "<strong>해당 uid</strong>를 방에서 퇴장시킨다.") 
    @ApiResponses({
        @ApiResponse(code = 401, message = "퇴장 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "사용자 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> leave(@PathVariable String userId, @PathVariable Long uid){
		
		Tile u = userService.getUserByUserId(userId);
		
		Planet conference = conferenceService.getConferenceByOid(u.getUid());
		Tile user = userService.getUserByUid(uid);
		
		if(u.getUid() == uid) {
			conference = conferenceService.conferenceLeaveAll(conference);
			return ResponseEntity.status(201).body(BaseResponseBody.of(201, "Host leave"));
		}else if(conference.getUsers().contains(user)){
			conference = conferenceService.conferenceLeave(conference, user);
			return ResponseEntity.status(200).body(BaseResponseBody.of(200, "Guest leave"));
		}else {
			return ResponseEntity.status(401).body(BaseResponseBody.of(401, "Conference disabled"));
		}
	}
	
	@PostMapping("/update")
	@ApiOperation(value = "방 수정", notes = "<strong>해당 oid</strong>방 제목, 설명을 수정한다.") 
    @ApiResponses({
        @ApiResponse(code = 401, message = "인증 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "사용자 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<? extends BaseResponseBody> update(@RequestBody @ApiParam(value="방 정보", required = true) TilePutReq conferenceInfo){
	
		if(conferenceService.conferenceModify(conferenceInfo)) {
			return ResponseEntity.status(200).body(BaseResponseBody.of(201, "Success"));
		}else {
			return ResponseEntity.status(200).body(BaseResponseBody.of(401, "Fail"));
		}
	}

}
