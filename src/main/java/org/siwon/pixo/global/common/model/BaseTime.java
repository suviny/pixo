package org.siwon.pixo.global.common.model;

import lombok.Getter;

import java.time.LocalDateTime;

/**
 * 도메인 모델의 생성 일시와 변경 일시를 관리하기 위한 추상 클래스
 *
 * @author 박 수 빈
 * @version 1.0
 */
@Getter
public abstract class BaseTime {

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    /**
     * {@code INSERT} 실행 전 생성 일시와 변경 일시를 초기화 한다.
     *
     * @param dateTime  데이터 생성 시점의 일시 정보
     */
    public void preInsert(LocalDateTime dateTime) {
        this.createdAt = dateTime;
        this.updatedAt = dateTime;
    }

    /**
     * {@code UPDATE} 실행 전 변경 일시를 현재 시점의 일시 정보로 갱신한다.
     *
     * @param dateTime  데이터 변경 시점의 일시 정보
     */
    public void preUpdate(LocalDateTime dateTime) {
        this.updatedAt = dateTime;
    }
}