package org.siwon.pixo.global.utils;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * 프로젝트 전역에서 도메인의 상태값의 처리를 위해 서로 다른 타입의 값들을 상응되는 의미별로 정의 및 관리하는 열거형
 *
 * @author 박 수 빈
 * @version 1.0
 */
@Getter
@RequiredArgsConstructor
public enum Status {

    YES (1, "Y", true),
    NO (0, "N", false)
    ;

    private final int number;

    private final String symbol;

    private final boolean flag;

    /**
     * 전달된 문자열과 일치하는 값을 지닌 상수의 논리형 상태값을 반환한다.
     *
     * @param source    논리형 상태값으로 변환하고자 하는 문자열
     * @return          전달된 값이 {@code "Y"}일 경우 {@code true}, {@code "N"}일 경우 {@code false}를 반환
     */
    public static boolean toBoolean(String source) {
        for (Status e : values()) {
            if (e.getSymbol().equals(source)) {
                return e.isFlag();
            }
        }
        throw new IllegalArgumentException("No constant found for '" + source + "'.");
    }

}