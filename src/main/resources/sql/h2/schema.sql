-- ********************************************************************************
-- Created new script by SUVINY on 26. 11. 5.
-- This script file is for defining DDL statements in H2 In-Memory
-- ********************************************************************************

-- DDL section...


-- # 사용자 테이블
DROP TABLE IF EXISTS USERS CASCADE;
CREATE TABLE IF NOT EXISTS USERS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 사용자 번호
    email               VARCHAR(55)             NOT NULL,                   -- 이메일
    nickname            VARCHAR(25)             NOT NULL,                   -- 닉네임
    name                VARCHAR(20)             NOT NULL,                   -- 이름
    login_type          VARCHAR(5)              NOT NULL,                   -- 로그인(인증) 유형
    is_enabled          CHAR(1)              	NOT NULL DEFAULT 'Y',         -- 계정의 활성화 여부
    deleted_yn          CHAR(1)                 NOT NULL DEFAULT 'N',       -- 계정 삭제 여부 (논리 삭제)
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 계정 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 계정 변경 일시
    deleted_at          DATETIME                NULL,                       -- 계정 삭제 일시
    PRIMARY KEY (id),
    CONSTRAINT UK_USERS_EMAIL UNIQUE KEY (email),
    CONSTRAINT UK_USERS_NICKNAME UNIQUE KEY (nickname)
);


-- # 사용자별 권한 매핑 테이블
DROP TABLE IF EXISTS USER_ROLES CASCADE;
CREATE TABLE IF NOT EXISTS USER_ROLES (
    user_id             INT                     NOT NULL,                   -- 사용자 번호
    role                VARCHAR(25)             NOT NULL,                   -- 권한명
    PRIMARY KEY (user_id, role),
    CONSTRAINT FK_USER_ROLES_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 로컬 인증(비밀번호) 정보 테이블
DROP TABLE IF EXISTS USER_CREDENTIALS CASCADE;
CREATE TABLE IF NOT EXISTS USER_CREDENTIALS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 인증 번호
    user_id             INT                     NOT NULL,                   -- 사용자 번호
    password            VARCHAR(255)            NOT NULL,                   -- 비밀번호
    updated_at          DATETIME                NOT NULL,                   -- 변경 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_USER_CREDENTIALS_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);



-- # 소셜 인증 정보 테이블
DROP TABLE IF EXISTS USER_OAUTH CASCADE;
CREATE TABLE IF NOT EXISTS USER_OAUTH (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 인증 번호
    user_id             INT                     NOT NULL,                   -- 사용자 번호
    provider            VARCHAR(20)             NOT NULL,                   -- 인증 서비스 제공자
    provider_id         VARCHAR(255)            NOT NULL,                   -- 인증 서비스 제공자의 고유 식별자
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_USER_OAUTH FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 로그인 이력 테이블
DROP TABLE IF EXISTS LOGIN_HISTORIES CASCADE;
CREATE TABLE IF NOT EXISTS LOGIN_HISTORIES (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 이력 번호
    user_id             INT                     NOT NULL,                   -- 사용자 번호
    ip_address          VARCHAR(45)             NOT NULL,                   -- 아이피 주소
    device_type         VARCHAR(15)             NOT NULL,                   -- 기기 유형
    os                  VARCHAR(50)             NOT NULL,                   -- 운영체제
    browser             VARCHAR(50)             NOT NULL,                   -- 브라우저
    login_at            DATETIME                NOT NULL,                   -- 로그인 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_LOGIN_HISTORIES FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 프로필 정보 테이블
DROP TABLE IF EXISTS PROFILES CASCADE;
CREATE TABLE IF NOT EXISTS PROFILES (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 프로필 번호
    user_id             INT                     NOT NULL,                   -- 사용자 번호
    profile_img_url     VARCHAR(255)            NULL,                       -- 프로필 이미지 저장 경로
    bio                 VARCHAR(150)            NULL,                       -- 한 줄 소개
    univ                VARCHAR(50)             NULL,                       -- 재학 또는 졸업한 대학명
    site_url            VARCHAR(255)            NULL,                       -- 개인 사이트 주소
    github_url          VARCHAR(255)            NULL,                       -- 개인 깃허브 주소
    updated_at          DATETIME                NOT NULL,                   -- 프로필 정보 변경 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_PROFILES_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 팀 정보 테이블
DROP TABLE IF EXISTS TEAMS CASCADE;
CREATE TABLE IF NOT EXISTS TEAMS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 팀 번호
    name                VARCHAR(100)            NOT NULL,                   -- 팀명
    introduction        VARCHAR(150)            NULL,                       -- 팀 소개글
    deleted_yn          CHAR(1)                 NOT NULL DEFAULT 'N',       -- 팀 정보 삭제 여부
    created_by          INT                     NOT NULL,                   -- 팀 정보 생성자 번호
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    deleted_at          DATETIME                NULL,                       -- 삭제 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_TEAMS_CREATED_BY FOREIGN KEY (created_by) REFERENCES USERS (id)
);


-- # 팀원 테이블
DROP TABLE IF EXISTS TEAM_USERS CASCADE;
CREATE TABLE IF NOT EXISTS TEAM_USERS (
    team_id             INT                     NOT NULL,   -- 팀 번호
    user_id             INT                     NOT NULL,   -- 사용자 번호
    is_captain          CHAR(1)                 NOT NULL DEFAULT 'N',   -- 팀장 여부
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 팀원 등록 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    PRIMARY KEY (team_id, user_id),
    CONSTRAINT FK_TEAM_USERS_TEAM_ID FOREIGN KEY (team_id) REFERENCES TEAMS (id),
    CONSTRAINT FK_TEAM_USERS_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 상위 업무 그룹 테이블
DROP TABLE IF EXISTS TASK_GROUPS CASCADE;
CREATE TABLE IF NOT EXISTS TASK_GROUPS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 상위 업무 그룹 번호
    name                VARCHAR(50)             NOT NULL,                   -- 그룹명
    used_yn             CHAR(1)                 NOT NULL DEFAULT 'N',       -- 사용 여부
    sort                INT                     NOT NULL DEFAULT 0,         -- 화면상 정렬 번호
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    PRIMARY KEY (id)
);


-- # 프로젝트 정보 테이블
DROP TABLE IF EXISTS PROJECTS CASCADE;
CREATE TABLE IF NOT EXISTS PROJECTS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 프로젝트 번호
    name                VARCHAR(100)            NOT NULL,                   -- 프로젝트명
    summary             VARCHAR(200)            NOT NULL,                   -- 프로젝트 소개
    team_id             INT                     NOT NULL,                   -- 프로젝트 진행 팀 번호
    user_id             INT                     NOT NULL,                   -- 프로젝트 관리자 번호
    start_date          DATE                    NOT NULL,                   -- 프로젝트 시작일
    end_date            DATE                    NOT NULL,                   -- 프로젝트 종료일
    status              CHAR(1)                 NOT NULL,                   -- 프로젝트 진행 상태 : 'W' : 대기 / 'P' : 진행 중  / 'D' : 완료
    deleted_yn          CHAR(1)                 NOT NULL DEFAULT 'N',       -- 삭제 여부
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 정보 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 정보 변경 일시
    deleted_at          DATETIME                NULL,                       -- 정보 삭제 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_PROJECTS_TEAM_ID FOREIGN KEY (team_id) REFERENCES TEAMS (id),
    CONSTRAINT FK_PROJECTS_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 프로젝트 업무 테이블
DROP TABLE IF EXISTS TASKS CASCADE;
CREATE TABLE IF NOT EXISTS TASKS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 업무 번호
    project_id          INT                     NOT NULL,                   -- 프로젝트 번호
    name                VARCHAR(250)            NOT NULL,                   -- 업무명
    parent_task_id      INT                     NULL,                       -- 상위 업무 번호
    start_date          DATE                    NOT NULL,                   -- 업무 시작일
    end_date            DATE                    NOT NULL,                   -- 업무 종료일
    actual_end_date     DATE                    NULL,                       -- 업무 실제 종료일
    status              CHAR(1)                 NOT NULL,                   -- 업무 진행 상태
    rate                INT                     NOT NULL DEFAULT 0,         -- 진행률
    sort                INT                     NOT NULL DEFAULT 0,         -- 화면상 정렬 번호
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_TASKS_PROJECT_ID FOREIGN KEY (project_id) REFERENCES PROJECTS (id)
);


-- # 프로젝트 업무 할당 테이블
DROP TABLE IF EXISTS TASK_ASSIGNMENTS CASCADE;
CREATE TABLE IF NOT EXISTS TASK_ASSIGNMENTS (
    task_id             INT                     NOT NULL,   -- 업무 번호
    user_id             INT                     NOT NULL,   -- 담당자 번호
    PRIMARY KEY (task_id, user_id)
);



-- # 프로젝트 업무 산출물 테이블
DROP TABLE IF EXISTS TASK_ATTACHMENTS CASCADE;
CREATE TABLE IF NOT EXISTS TASK_ATTACHMENTS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 산출물 번호
    task_id             INT                     NOT NULL,                   -- 업무 번호
    user_id             INT                     NOT NULL,                   -- 작성자 번호
    attachment_type     VARCHAR(15)             NOT NULL,                   -- 산출물 유형 : 회의록, 설계서, 기획서
    original_name       VARCHAR(250)            NOT NULL,                   -- 파일 원본명
    saved_path          VARCHAR(255)            NOT NULL,                   -- 저장 경로
    saved_name          VARCHAR(255)            NOT NULL,                   -- 저장명
    extension           VARCHAR(10)             NOT NULL,                   -- 확장자명
    file_size           INT                     NOT NULL,                   -- 파일 크기
    deleted_yn          CHAR(1)                 NOT NULL DEFAULT 'N',       -- 삭제 여부
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 산출물 업로드 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 산출물 정보 변경 일시
    deleted_at          DATETIME                NULL,                       -- 삭제 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_TASK_ATTACHMENTS_TASK_ID FOREIGN KEY (task_id) REFERENCES TASKS (id),
    CONSTRAINT FK_TASK_ATTACHMENTS_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 프로젝트 업무 항목 테이블
DROP TABLE IF EXISTS TASK_ENTRIES CASCADE;
CREATE TABLE IF NOT EXISTS TASK_ENTRIES (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 업무 항목 번호
    task_id             INT                     NOT NULL,                   -- 업무 번호
    user_id             INT                     NOT NULL,                   -- 담당자 번호
    content             VARCHAR(300)            NOT NULL,                   -- 업무 항목의 본문
    is_completed        CHAR(1)                 NOT NULL,                   -- 항목 완료 여부
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_TASK_ENTRIES_TASK_ID FOREIGN KEY (task_id) REFERENCES TASKS (id),
    CONSTRAINT FK_TASK_ENTRIES_USER_ID FOREIGN KEY (user_id) REFERENCES USERS (id)
);


-- # 이슈 테이블
DROP TABLE IF EXISTS ISSUES CASCADE;
CREATE TABLE IF NOT EXISTS ISSUES (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 이슈 번호
    task_id             INT                     NOT NULL,                   -- 업무 번호
    reporter_id         INT                     NOT NULL,                   -- 이슈 등록자 번호
    assignee_id         INT                     NOT NULL,                   -- 이슈 담당자 번호
    title               VARCHAR(200)            NOT NULL,                   -- 이슈 제목
    content             TEXT                    NOT NULL,                   -- 이슈 내용
    status              VARCHAR(8)              NOT NULL,                   -- 이슈 처리 상태 (OPEN : 헤결되지 않음 / CLOSED : 해결)
    resolved_at         DATETIME                NOT NULL,                   -- 해결된 일시
    created_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP, -- 생성 일시
    updated_at          DATETIME                NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 변경 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_ISSUES_TASK_ID FOREIGN KEY (task_id) REFERENCES TASKS (id),
    CONSTRAINT FK_ISSUES_REPORTER_ID FOREIGN KEY (reporter_id) REFERENCES USERS (id)
    CONSTRAINT FK_ISSUES_ASSIGNEE_ID FOREIGN KEY (assignee_id) REFERENCES USERS (id)
);


-- # 알림 테이블
DROP TABLE IF EXISTS NOTIFICATIONS CASCADE;
CREATE TABLE IF NOT EXISTS NOTIFICATIONS (
    id                  INT                     NOT NULL AUTO_INCREMENT,    -- 알림 번호
    task_id             INT                     NOT NULL,                   -- 업무 번호
    receiver_id         INT                     NOT NULL,                   -- 알림 대상자 번호
    content             VARCHAR(200)            NOT NULL,                   -- 알림 내용
    target_url          VARCHAR(255)            NULL,                       -- 알림의 대상의 경로
    is_read             CHAR(1)                 NOT NULL DEFAULT 'N',       -- 알림 확인 여부
    created_at          DATETIME               NOT NULL CURRENT_TIMESTAMP, -- 생성 일시
    PRIMARY KEY (id),
    CONSTRAINT FK_NOTIFICATIONS_TASK_ID FOREIGN KEY (task_id) REFERENCES TASKS (id),
    CONSTRAINT FK_NOTIFICATIONS_RECEIVER_ID FOREIGN KEY (receiver_id) REFERENCES USERS (id)
);