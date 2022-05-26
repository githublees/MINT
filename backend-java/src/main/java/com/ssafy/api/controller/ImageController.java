package com.ssafy.api.controller;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.ssafy.api.response.FileDto;
import com.ssafy.common.model.response.BaseResponseBody;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

@Api(value = "ImageAPI")
@CrossOrigin("*")
@RestController
@RequestMapping("/image")
public class ImageController {

	@Value("${image.file.path}")
	private String filePath;
	
	@PostMapping("/upload")
	@ApiOperation(value = "이미지 업로드", notes = "이미지를 업로드 합니다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "업로드 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "업로드 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<FileDto> upload(@RequestParam("uploadfile") MultipartFile uploadfile) { 
		FileDto dto = new FileDto(uploadfile.getOriginalFilename());
		File newFileName = new File(filePath + dto.getFileName()); 
		try { 
			uploadfile.transferTo(newFileName); 
		} catch (Exception e) { 
			e.printStackTrace();
		}
		return ResponseEntity.status(200).body(dto); 
	}

	
	@GetMapping("/download")
	@ApiOperation(value = "이미지 다운로드", notes = "이미지 파일을 반환합니다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "다운로드 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 401, message = "다운로드 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "파일 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<Resource> download(@RequestParam("filename") String filename) throws IOException { 
		Path path = Paths.get(filePath + filename); 
		String contentType = Files.probeContentType(path); 
		
		HttpHeaders headers = new HttpHeaders(); 
		headers.setContentDisposition( ContentDisposition.builder("attachment") 
				.filename(filename, StandardCharsets.UTF_8) 
				.build()); 
		headers.add(HttpHeaders.CONTENT_TYPE, contentType); 
		
		Resource resource = new InputStreamResource(Files.newInputStream(path)); 
		if(!resource.exists()) return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		
		return new ResponseEntity<>(resource, headers, HttpStatus.OK); }

	
	
	@GetMapping("/display")
	@ApiOperation(value = "이미지 조회", notes = "<img> 태그의 src 속성용 uri를 반환합니다.") 
    @ApiResponses({
        @ApiResponse(code = 201, message = "조회 성공", response = BaseResponseBody.class),
        @ApiResponse(code = 400, message = "조회 실패", response = BaseResponseBody.class),
        @ApiResponse(code = 404, message = "파일 없음", response = BaseResponseBody.class),
        @ApiResponse(code = 500, message = "서버 오류", response = BaseResponseBody.class)
    })
	public ResponseEntity<Resource> display(@RequestParam("filename") String filename) { 
		Resource resource = new FileSystemResource(filePath + filename); 
		
		if(!resource.exists()) return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND); 
		
		HttpHeaders header = new HttpHeaders(); 
		Path path = null; 
		try{ 
			path = Paths.get(filePath + filename); 
			header.add("Content-type", Files.probeContentType(path)); 
		}catch(IOException e) { 
			e.printStackTrace(); 
		} 
		
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK); 
	}


}
