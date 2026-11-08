-- ********************************************************************************
-- Created new script by SUVINY on 26. 11. 5.
-- This script file is for defining DML statements in H2 In-Memory
-- ********************************************************************************

-- DDL section...


INSERT INTO TASK_GROUPS (
    name,
    sort,
    created_at,
    updated_at
) VALUES (
    '기획 및 요구사항 분석',
    1,
    NOW(),
    NOW(),
);

INSERT INTO TASK_GROUPS (
    name,
    sort,
    created_at,
    updated_at
) VALUES (
    '설계',
    2,
    NOW(),
    NOW(),
);

INSERT INTO TASK_GROUPS (
    name,
    sort,
    created_at,
    updated_at
) VALUES (
    '구현',
    3,
    NOW(),
    NOW(),
);

INSERT INTO TASK_GROUPS (
    name,
    sort,
    created_at,
    updated_at
) VALUES (
    '테스트 및 유지보수',
    4,
    NOW(),
    NOW(),
);

