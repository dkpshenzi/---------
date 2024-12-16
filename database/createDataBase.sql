/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : 2024_database

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 15/12/2024 20:39:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for batch
-- ----------------------------
DROP TABLE IF EXISTS `batch`;
CREATE TABLE `batch`  (
  `BatchId` int NOT NULL AUTO_INCREMENT,
  `Batch` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`BatchId`) USING BTREE,
  CONSTRAINT ` batch输入格式检查` CHECK (regexp_like(`Batch`,_utf8mb4'[0-9]{4}-[0-9]{2}'))
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of batch
-- ----------------------------
INSERT INTO `batch` VALUES (1, '2024-06');
INSERT INTO `batch` VALUES (2, '2024-05');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `DepartmentId` int NOT NULL AUTO_INCREMENT,
  `DepartmentName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`DepartmentId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (1, '智能科学与工程学院');
INSERT INTO `department` VALUES (2, '国际能源学院');

-- ----------------------------
-- Table structure for interviewscore
-- ----------------------------
DROP TABLE IF EXISTS `interviewscore`;
CREATE TABLE `interviewscore`  (
  `InterviewScoreId` int NOT NULL AUTO_INCREMENT,
  `StudentId` int NULL DEFAULT NULL,
  `TeacherId` int NULL DEFAULT NULL,
  `CriteriaId` int NULL DEFAULT NULL,
  `Score` float NOT NULL DEFAULT 0,
  `ScoringTime` date NOT NULL,
  PRIMARY KEY (`InterviewScoreId`) USING BTREE,
  INDEX `StudentId`(`StudentId` ASC) USING BTREE,
  INDEX `TeacherId`(`TeacherId` ASC) USING BTREE,
  INDEX `CriteriaId`(`CriteriaId` ASC) USING BTREE,
  CONSTRAINT `interviewscore_ibfk_1` FOREIGN KEY (`StudentId`) REFERENCES `student` (`StudentId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `interviewscore_ibfk_2` FOREIGN KEY (`TeacherId`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `interviewscore_ibfk_3` FOREIGN KEY (`CriteriaId`) REFERENCES `scoringcriteria` (`CriteriaId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `分数范围限制` CHECK ((`Score` >= 0) and (`Score` <= 100))
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of interviewscore
-- ----------------------------
INSERT INTO `interviewscore` VALUES (11, 1, 1, 4, 20, '2024-12-15');
INSERT INTO `interviewscore` VALUES (12, 1, 1, 5, 20, '2024-12-15');
INSERT INTO `interviewscore` VALUES (13, 1, 1, 6, 20, '2024-12-15');
INSERT INTO `interviewscore` VALUES (22, 2, 1, 4, 60, '2024-12-15');
INSERT INTO `interviewscore` VALUES (23, 2, 1, 5, 33, '2024-12-15');
INSERT INTO `interviewscore` VALUES (24, 2, 1, 6, 66, '2024-12-15');
INSERT INTO `interviewscore` VALUES (25, 7, 1, 4, 90, '2024-12-15');
INSERT INTO `interviewscore` VALUES (26, 7, 1, 5, 99, '2024-12-15');
INSERT INTO `interviewscore` VALUES (27, 7, 1, 6, 88, '2024-12-15');
INSERT INTO `interviewscore` VALUES (28, 8, 1, 4, 23, '2024-12-15');
INSERT INTO `interviewscore` VALUES (29, 8, 1, 5, 21, '2024-12-15');
INSERT INTO `interviewscore` VALUES (30, 8, 1, 6, 23, '2024-12-15');
INSERT INTO `interviewscore` VALUES (31, 8, 1, 7, 21, '2024-12-15');
INSERT INTO `interviewscore` VALUES (32, 8, 1, 8, 12, '2024-12-15');

-- ----------------------------
-- Table structure for major
-- ----------------------------
DROP TABLE IF EXISTS `major`;
CREATE TABLE `major`  (
  `MajorId` int NOT NULL AUTO_INCREMENT,
  `MajorName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DepartmentId` int NULL DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`MajorId`) USING BTREE,
  INDEX `DepartmentId`(`DepartmentId` ASC) USING BTREE,
  CONSTRAINT `major_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `department` (`DepartmentId`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES (5, '工业工程', 1, 1);
INSERT INTO `major` VALUES (6, '自动化', 2, 1);

-- ----------------------------
-- Table structure for scoringcriteria
-- ----------------------------
DROP TABLE IF EXISTS `scoringcriteria`;
CREATE TABLE `scoringcriteria`  (
  `CriteriaId` int NOT NULL AUTO_INCREMENT,
  `CriteriaName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '无',
  `CreateTime` datetime NOT NULL,
  PRIMARY KEY (`CriteriaId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of scoringcriteria
-- ----------------------------
INSERT INTO `scoringcriteria` VALUES (4, '外语听说能力', '无', '2024-12-09 16:58:27');
INSERT INTO `scoringcriteria` VALUES (5, '大学阶段学习情况', '无', '2024-12-15 02:15:09');
INSERT INTO `scoringcriteria` VALUES (6, '对本学科理论知识和应用技能考查', '无', '2024-12-15 02:34:59');
INSERT INTO `scoringcriteria` VALUES (7, '创新精神及创新能力', '无', '2024-12-15 16:33:11');
INSERT INTO `scoringcriteria` VALUES (8, '综合素质和能力', '无', '2024-12-15 16:33:32');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `StudentId` int NOT NULL AUTO_INCREMENT,
  `StudentName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Gender` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `UniversityId` int NOT NULL,
  `MajorId` int NULL DEFAULT NULL,
  `Status` enum('已报名','笔试完成','面试完成','已录取','未录取') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '已报名',
  `BatchId` int NULL DEFAULT NULL,
  `InitialTestScore` float NOT NULL,
  PRIMARY KEY (`StudentId`) USING BTREE,
  INDEX `MajorId`(`MajorId` ASC) USING BTREE,
  INDEX `batchid`(`BatchId` ASC) USING BTREE,
  CONSTRAINT `batchid` FOREIGN KEY (`BatchId`) REFERENCES `batch` (`BatchId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`MajorId`) REFERENCES `major` (`MajorId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `初始分取值范围` CHECK ((`InitialTestScore` >= 0) and (`InitialTestScore` <= 100))
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (1, 'a', '男', 1, 5, '面试完成', 1, 100);
INSERT INTO `student` VALUES (2, 'b', '女', 1, 6, '面试完成', 1, 80);
INSERT INTO `student` VALUES (7, 'c', '女', 1, 5, '面试完成', 1, 100);
INSERT INTO `student` VALUES (8, 'd', '女', 1, 6, '笔试完成', 1, 100);
INSERT INTO `student` VALUES (10, 'e', '男', 1, 5, '已报名', 1, 100);
INSERT INTO `student` VALUES (11, 'f', '女', 1, 6, '已报名', 1, 50);
INSERT INTO `student` VALUES (12, 'g', '男', 1, 5, '已报名', 1, 100);
INSERT INTO `student` VALUES (13, 'h', '女', 1, 5, '已报名', 1, 50);
INSERT INTO `student` VALUES (14, 'i', '女', 1, 5, '已报名', 1, 70);
INSERT INTO `student` VALUES (16, 'j', '女', 1, 5, '已报名', 1, 60);
INSERT INTO `student` VALUES (24, 'k', '女', 1, 5, '已报名', 1, 20);
INSERT INTO `student` VALUES (25, 'l', '男', 2, 5, '已报名', 1, 100);

-- ----------------------------
-- Table structure for teacher
-- ----------------------------
DROP TABLE IF EXISTS `teacher`;
CREATE TABLE `teacher`  (
  `TeacherId` int NOT NULL AUTO_INCREMENT,
  `TeacherName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Gender` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DepartmentId` int NULL DEFAULT NULL,
  `Title` enum('教授','副教授','讲师','助教') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `IsActive` tinyint NOT NULL DEFAULT 1,
  `Contact` int NOT NULL,
  PRIMARY KEY (`TeacherId`) USING BTREE,
  INDEX `DepartmentId`(`DepartmentId` ASC) USING BTREE,
  CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `department` (`DepartmentId`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1, 'a', '男', 1, '教授', 1, 0);
INSERT INTO `teacher` VALUES (2, 'b', '男', 1, '教授', 1, 0);
INSERT INTO `teacher` VALUES (3, 'c', '女', 1, '副教授', 1, 0);
INSERT INTO `teacher` VALUES (4, 'd', '女', 2, '副教授', 1, 0);
INSERT INTO `teacher` VALUES (5, 'e', '女', 1, '讲师', 1, 0);
INSERT INTO `teacher` VALUES (6, 'f', '女', 2, '教授', 2, 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `UserId` int NOT NULL AUTO_INCREMENT,
  `Role` enum('Admin','Worker') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'Worker',
  `Account` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `CreateTime` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  `Email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`UserId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'Worker', 'dkp', '1', '2024-12-14 23:19:10', '1@qq.com');
INSERT INTO `user` VALUES (2, 'Admin', 'dkpzi', '1', '2024-12-14 22:52:18', '1@qq.com');
INSERT INTO `user` VALUES (13, 'Admin', 'Aimer', 'Aimer', '2024-12-15 01:10:07', 'aimer@qq.com');
INSERT INTO `user` VALUES (14, 'Admin', 'dyj', '1', '2024-12-15 15:02:49', '1@qq.com');

-- ----------------------------
-- Table structure for weight
-- ----------------------------
DROP TABLE IF EXISTS `weight`;
CREATE TABLE `weight`  (
  `WeightId` int NOT NULL AUTO_INCREMENT,
  `WeightName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Weight` double NOT NULL,
  PRIMARY KEY (`WeightId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of weight
-- ----------------------------
INSERT INTO `weight` VALUES (1, '初试权重', 0.7);
INSERT INTO `weight` VALUES (2, '复试笔试权重', 0.1);
INSERT INTO `weight` VALUES (3, '复试面试权重', 0.2);

-- ----------------------------
-- Table structure for writtentestscore
-- ----------------------------
DROP TABLE IF EXISTS `writtentestscore`;
CREATE TABLE `writtentestscore`  (
  `WrittenTestScoreId` int NOT NULL AUTO_INCREMENT,
  `StudentId` int NULL DEFAULT NULL,
  `Score` float NOT NULL DEFAULT 0,
  `Time` date NOT NULL,
  PRIMARY KEY (`WrittenTestScoreId`) USING BTREE,
  INDEX `StudentId`(`StudentId` ASC) USING BTREE,
  CONSTRAINT `writtentestscore_ibfk_1` FOREIGN KEY (`StudentId`) REFERENCES `student` (`StudentId`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `分数取值范围` CHECK ((`Score` >= 0) and (`Score` <= 100))
) ENGINE = InnoDB AUTO_INCREMENT = 79 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of writtentestscore
-- ----------------------------
INSERT INTO `writtentestscore` VALUES (75, 1, 50, '2024-12-15');
INSERT INTO `writtentestscore` VALUES (76, 2, 90, '2024-12-15');
INSERT INTO `writtentestscore` VALUES (77, 7, 90, '2024-12-15');
INSERT INTO `writtentestscore` VALUES (78, 8, 96, '2024-12-15');

-- ----------------------------
-- View structure for interviewscore_view
-- ----------------------------
DROP VIEW IF EXISTS `interviewscore_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `interviewscore_view` AS select `i`.`InterviewScoreId` AS `InterviewScoreId`,`i`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`i`.`TeacherId` AS `TeacherId`,`t`.`TeacherName` AS `TeacherName`,`c`.`CriteriaName` AS `CriteriaName`,`i`.`Score` AS `Score`,`i`.`ScoringTime` AS `ScoringTime`,`b`.`Batch` AS `Batch` from ((((`interviewscore` `i` join `student` `s` on((`i`.`StudentId` = `s`.`StudentId`))) join `teacher` `t` on((`i`.`TeacherId` = `t`.`TeacherId`))) join `scoringcriteria` `c` on((`i`.`CriteriaId` = `c`.`CriteriaId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`)));

-- ----------------------------
-- View structure for major_view
-- ----------------------------
DROP VIEW IF EXISTS `major_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `major_view` AS select `m`.`MajorId` AS `MajorId`,`m`.`MajorName` AS `MajorName`,`d`.`DepartmentName` AS `DepartmentName`,`m`.`IsActive` AS `IsActive` from (`major` `m` join `department` `d` on((`m`.`DepartmentId` = `d`.`DepartmentId`)));

-- ----------------------------
-- View structure for student_view
-- ----------------------------
DROP VIEW IF EXISTS `student_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `student_view` AS select `s`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`s`.`Gender` AS `Gender`,`s`.`UniversityId` AS `UniversityId`,`m`.`MajorName` AS `MajorName`,`s`.`Status` AS `Status`,`b`.`Batch` AS `Batch`,`s`.`InitialTestScore` AS `InitialTestScore` from ((`student` `s` join `major` `m` on((`s`.`MajorId` = `m`.`MajorId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`)));

-- ----------------------------
-- View structure for teacher_view
-- ----------------------------
DROP VIEW IF EXISTS `teacher_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `teacher_view` AS select `t`.`TeacherId` AS `TeacherId`,`t`.`TeacherName` AS `TeacherName`,`t`.`Gender` AS `Gender`,`d`.`DepartmentName` AS `DepartmentName`,`t`.`Title` AS `Title`,`t`.`IsActive` AS `IsActive`,`t`.`Contact` AS `Contact` from (`teacher` `t` join `department` `d` on((`t`.`DepartmentId` = `d`.`DepartmentId`)));

-- ----------------------------
-- View structure for totalscoreview
-- ----------------------------
DROP VIEW IF EXISTS `totalscoreview`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `totalscoreview` AS select `student_score`.`StudentId` AS `StudentId`,`student_score`.`StudentName` AS `StudentName`,`student_score`.`DepartmentName` AS `DepartmentName`,`student_score`.`MajorName` AS `MajorName`,`student_score`.`InitialTestScore` AS `InitialTestScore`,`student_score`.`WrittenTestScore` AS `WrittenTestScore`,`interview_score`.`InterviewScore` AS `InterviewScore`,round((((`weight1`.`Weight` * `student_score`.`InitialTestScore`) + (`weight2`.`Weight` * `student_score`.`WrittenTestScore`)) + (`weight3`.`Weight` * `interview_score`.`InterviewScore`)),2) AS `TotalScore`,(case when (round((((`weight1`.`Weight` * `student_score`.`InitialTestScore`) + (`weight2`.`Weight` * `student_score`.`WrittenTestScore`)) + (`weight3`.`Weight` * `interview_score`.`InterviewScore`)),2) > 50) then 'Yes' else 'No' end) AS `IsPassed` from (((((select `student_list1`.`StudentId` AS `StudentId`,`student_list1`.`StudentName` AS `StudentName`,`student_list2`.`DepartmentName` AS `DepartmentName`,`student_list2`.`MajorName` AS `MajorName`,`student_list1`.`InitialTestScore` AS `InitialTestScore`,`student_list1`.`WrittenTestScore` AS `WrittenTestScore`,`student_list1`.`Status` AS `Status` from ((select `student`.`StudentId` AS `StudentId`,`student`.`StudentName` AS `StudentName`,`student`.`MajorId` AS `MajorId`,`student`.`InitialTestScore` AS `InitialTestScore`,`writtentestscore`.`Score` AS `WrittenTestScore`,`student`.`Status` AS `Status` from (`student` left join `writtentestscore` on((`student`.`StudentId` = `writtentestscore`.`StudentId`)))) `student_list1` join (select `major`.`MajorId` AS `MajorId`,`major`.`MajorName` AS `MajorName`,`department`.`DepartmentName` AS `DepartmentName` from (`major` join `department` on((`major`.`DepartmentId` = `department`.`DepartmentId`)))) `student_list2` on((`student_list1`.`MajorId` = `student_list2`.`MajorId`)))) `student_score` left join (select `interviewscore`.`StudentId` AS `StudentId`,round(avg(`interviewscore`.`Score`),2) AS `InterviewScore` from `interviewscore` group by `interviewscore`.`StudentId`) `interview_score` on((`student_score`.`StudentId` = `interview_score`.`StudentId`))) join (select `weight`.`Weight` AS `Weight` from `weight` where (`weight`.`WeightName` = '初试权重')) `weight1` on((1 = 1))) join (select `weight`.`Weight` AS `Weight` from `weight` where (`weight`.`WeightName` = '复试笔试权重')) `weight2` on((1 = 1))) join (select `weight`.`Weight` AS `Weight` from `weight` where (`weight`.`WeightName` = '复试面试权重')) `weight3` on((1 = 1))) where (`student_score`.`Status` = '面试完成');

-- ----------------------------
-- View structure for writtentestscore_view
-- ----------------------------
DROP VIEW IF EXISTS `writtentestscore_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `writtentestscore_view` AS select `w`.`WrittenTestScoreId` AS `WrittenTestScoreId`,`w`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`w`.`Score` AS `Score`,`w`.`Time` AS `Time`,`b`.`Batch` AS `Batch` from ((`writtentestscore` `w` join `student` `s` on((`s`.`StudentId` = `w`.`StudentId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`)));

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `scoring_time`;
delimiter ;;
CREATE TRIGGER `scoring_time` BEFORE INSERT ON `interviewscore` FOR EACH ROW BEGIN
	SET NEW.ScoringTime = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `笔试了才能面试`;
delimiter ;;
CREATE TRIGGER `笔试了才能面试` BEFORE INSERT ON `interviewscore` FOR EACH ROW BEGIN
	IF NOT EXISTS(
		SELECT 1
		FROM student s
		WHERE s.StudentId = NEW.StudentId and s.Status = '笔试完成'
	)THEN 
	 SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = '插入失败，学生未笔试';
 END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table scoringcriteria
-- ----------------------------
DROP TRIGGER IF EXISTS `自动填充时间`;
delimiter ;;
CREATE TRIGGER `自动填充时间` BEFORE INSERT ON `scoringcriteria` FOR EACH ROW BEGIN
	SET NEW.CreateTime = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `before_students_insert`;
delimiter ;;
CREATE TRIGGER `before_students_insert` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
    SET NEW.CreateTime = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table writtentestscore
-- ----------------------------
DROP TRIGGER IF EXISTS `before_insert_writtentestscore`;
delimiter ;;
CREATE TRIGGER `before_insert_writtentestscore` BEFORE INSERT ON `writtentestscore` FOR EACH ROW BEGIN
    SET NEW.Time = NOW();
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table writtentestscore
-- ----------------------------
DROP TRIGGER IF EXISTS `报名了才能笔试`;
delimiter ;;
CREATE TRIGGER `报名了才能笔试` BEFORE INSERT ON `writtentestscore` FOR EACH ROW BEGIN
	IF NOT EXISTS(
		SELECT 1
		FROM student s
		WHERE s.StudentId = NEW.StudentId and s.Status = '已报名'
	)THEN 
	 SIGNAL SQLSTATE '45000'
	 SET MESSAGE_TEXT = '插入失败，学生未报名';
 END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table writtentestscore
-- ----------------------------
DROP TRIGGER IF EXISTS `笔试通过`;
delimiter ;;
CREATE TRIGGER `笔试通过` AFTER INSERT ON `writtentestscore` FOR EACH ROW BEGIN
	IF EXISTS(
		SELECT 1
		FROM student s
		WHERE s.StudentId = NEW.StudentId AND s.Status = '已报名'
	)THEN 
		UPDATE student s
		SET s.Status = '笔试完成'
		WHERE s.StudentId = NEW.StudentId;
	END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

-- ----------------------------
-- 创建Admin和Worker角色的权限
-- ----------------------------
CREATE USER `Admin`@`%` IDENTIFIED WITH mysql_native_password;
GRANT `root`@`localhost` TO `Admin`@`%`;
SET DEFAULT ROLE `root`@`localhost` TO `Admin`@`%`;
GRANT Alter, Alter Routine, Create, Create Routine, Create Temporary Tables, Create User, Create View, Delete, Drop, Event, Execute, File, Grant Option, Index, Insert, Lock Tables, Process, References, Reload, Replication Client, Replication Slave, Select, Show Databases, Show View, Shutdown, Super, Trigger, Update ON *.* TO `Admin`@`%`;

CREATE USER `Worker`@`%` IDENTIFIED WITH mysql_native_password;
GRANT Select ON TABLE `2024_database`.`batch` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`department` TO `Worker`@`%`;
GRANT Delete, Insert, Select, Update ON TABLE `2024_database`.`interviewscore` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`interviewscore_view` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`major` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`major_view` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`scoringcriteria` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`student` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`student_view` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`teacher` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`teacher_view` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`totalscoreview` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`weight` TO `Worker`@`%`;
GRANT Delete, Insert, Select, Update ON TABLE `2024_database`.`writtentestscore` TO `Worker`@`%`;
GRANT Select ON TABLE `2024_database`.`writtentestscore_view` TO `Worker`@`%`;