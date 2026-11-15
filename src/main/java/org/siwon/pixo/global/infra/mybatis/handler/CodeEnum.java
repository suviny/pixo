package org.siwon.pixo.global.infra.mybatis.handler;

/**
 * 데이터베이스의 코드값과 매핑되는 열거형의 공통 규약을 정의한 인터페이스
 *
 * @author 박 수 빈
 * @version 1.0
 */
public interface CodeEnum {

    /**
     * 데이터베이스에 저장 및 조회될 문자열 타입의 코드값을 반환한다.
     */
    String getCode();

    /**
     * 화면 표시를 위한 코드의 라벨을 반환한다.
     */
    String getLabel();

}