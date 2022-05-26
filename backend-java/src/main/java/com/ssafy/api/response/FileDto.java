package com.ssafy.api.response;

import java.sql.Timestamp;
import java.util.UUID;

public class FileDto {
	private String filename;
	
	//추가해야될 제약 조건
	//1. 파일이름이 너무 긴 경우 파일 생성 및 이동이 제약될 수 있음
	public FileDto(final String originalName) {
		UUID uuid = UUID.randomUUID();
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		filename = uuid.toString()+"_"+System.currentTimeMillis()+"_"+originalName;
	}
	
	public String getFileName() {
		return filename;
	}
}
