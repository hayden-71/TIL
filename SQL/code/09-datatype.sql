USE lecture;

DROP TABLE dt_demo;
CREATE TABLE dt_demo (
	id 		INT 		AUTO_INCREMENT PRIMARY KEY,
	name	 VARCHAR(20) NOT NULL,
    nickname VARCHAR(20),
    birth 	 DATE,
    score 	 FLOAT,
    salary	 DECIMAL,
    description TEXT,
    is_active  BOOL 		DEFAULT TRUE,
    created_at  DATETIME 	DEFAULT CURRENT_TIMESTAMP
);

DESC dt_demo;