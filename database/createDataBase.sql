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

 Date: 19/12/2024 23:36:24
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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of batch
-- ----------------------------
INSERT INTO `batch` VALUES (1, '2024-06');
INSERT INTO `batch` VALUES (2, '2023-06');

-- ----------------------------
-- Table structure for classroom
-- ----------------------------
DROP TABLE IF EXISTS `classroom`;
CREATE TABLE `classroom`  (
  `ClassroomId` int NOT NULL AUTO_INCREMENT,
  `ClassroomName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`ClassroomId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of classroom
-- ----------------------------
INSERT INTO `classroom` VALUES (1, '教120');
INSERT INTO `classroom` VALUES (2, '阶梯4');

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
  `Score1` float NOT NULL,
  `Score2` float NOT NULL,
  `Score3` float NOT NULL,
  PRIMARY KEY (`InterviewScoreId`) USING BTREE,
  INDEX `学生`(`StudentId` ASC) USING BTREE,
  INDEX `老师`(`TeacherId` ASC) USING BTREE,
  CONSTRAINT `学生` FOREIGN KEY (`StudentId`) REFERENCES `student` (`StudentId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `老师` FOREIGN KEY (`TeacherId`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of interviewscore
-- ----------------------------
INSERT INTO `interviewscore` VALUES (1, 2022101895, 1, 20, 30, 50);
INSERT INTO `interviewscore` VALUES (2, 2022101895, 2, 20, 30, 50);
INSERT INTO `interviewscore` VALUES (3, 2022101895, 3, 20, 30, 50);
INSERT INTO `interviewscore` VALUES (4, 2022101895, 4, 20, 30, 50);
INSERT INTO `interviewscore` VALUES (5, 2022101895, 5, 20, 30, 50);
INSERT INTO `interviewscore` VALUES (6, 2022101898, 1, 23, 23, 23);
INSERT INTO `interviewscore` VALUES (7, 2022101898, 2, 23, 23, 23);
INSERT INTO `interviewscore` VALUES (8, 2022101898, 3, 10, 23, 23);
INSERT INTO `interviewscore` VALUES (9, 2022101898, 4, 23, 23, 23);
INSERT INTO `interviewscore` VALUES (10, 2022101898, 5, 23, 23, 23);
INSERT INTO `interviewscore` VALUES (11, 2022101896, 1, 12, 12, 12);

-- ----------------------------
-- Table structure for major
-- ----------------------------
DROP TABLE IF EXISTS `major`;
CREATE TABLE `major`  (
  `MajorId` int NOT NULL AUTO_INCREMENT,
  `MajorName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `DepartmentId` int NULL DEFAULT NULL,
  PRIMARY KEY (`MajorId`) USING BTREE,
  INDEX `DepartmentId`(`DepartmentId` ASC) USING BTREE,
  CONSTRAINT `major_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `department` (`DepartmentId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of major
-- ----------------------------
INSERT INTO `major` VALUES (1, '工业工程', 1);
INSERT INTO `major` VALUES (2, '自动化', 2);
INSERT INTO `major` VALUES (3, '人工智能', 1);

-- ----------------------------
-- Table structure for schedule
-- ----------------------------
DROP TABLE IF EXISTS `schedule`;
CREATE TABLE `schedule`  (
  `ScheduleId` int NOT NULL AUTO_INCREMENT,
  `ClassroomId` int NULL DEFAULT NULL,
  `BatchId` int NULL DEFAULT NULL,
  `Teacher1Id` int NULL DEFAULT NULL,
  `Teacher2Id` int NULL DEFAULT NULL,
  `Teacher3Id` int NULL DEFAULT NULL,
  `Teacher4Id` int NULL DEFAULT NULL,
  `Teacher5Id` int NULL DEFAULT NULL,
  `StartTime` time NOT NULL,
  `EndTime` time NOT NULL,
  `Datetime` date NOT NULL,
  PRIMARY KEY (`ScheduleId`) USING BTREE,
  INDEX `schedule_ibfk_1`(`BatchId` ASC) USING BTREE,
  INDEX `schedule_ibfk_2`(`Teacher1Id` ASC) USING BTREE,
  INDEX `schedule_ibfk_3`(`Teacher2Id` ASC) USING BTREE,
  INDEX `schedule_ibfk_4`(`Teacher3Id` ASC) USING BTREE,
  INDEX `schedule_ibfk_5`(`Teacher4Id` ASC) USING BTREE,
  INDEX `schedule_ibfk_6`(`ClassroomId` ASC) USING BTREE,
  CONSTRAINT `schedule_ibfk_1` FOREIGN KEY (`BatchId`) REFERENCES `batch` (`BatchId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_2` FOREIGN KEY (`Teacher1Id`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_3` FOREIGN KEY (`Teacher2Id`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_4` FOREIGN KEY (`Teacher3Id`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_5` FOREIGN KEY (`Teacher4Id`) REFERENCES `teacher` (`TeacherId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `schedule_ibfk_6` FOREIGN KEY (`ClassroomId`) REFERENCES `classroom` (`ClassroomId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule
-- ----------------------------
INSERT INTO `schedule` VALUES (1, 1, 1, 2, 1, 3, 4, 5, '14:30:00', '17:00:00', '2024-12-18');
INSERT INTO `schedule` VALUES (2, 1, 1, 2, 1, 3, 4, 5, '18:00:00', '19:00:00', '2024-12-18');

-- ----------------------------
-- Table structure for student
-- ----------------------------
DROP TABLE IF EXISTS `student`;
CREATE TABLE `student`  (
  `StudentId` int NOT NULL AUTO_INCREMENT,
  `StudentName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Gender` enum('男','女') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `University` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `MajorId` int NULL DEFAULT NULL,
  `Status` enum('已报名','笔试完成','面试完成','已录取','未录取') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT '已报名',
  `BatchId` int NULL DEFAULT NULL,
  `InitialTestScore` float NOT NULL,
  `ScheduleId` int NULL DEFAULT NULL,
  `Contact` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`StudentId`) USING BTREE,
  INDEX `MajorId`(`MajorId` ASC) USING BTREE,
  INDEX `batchid`(`BatchId` ASC) USING BTREE,
  INDEX `student_ibfk_2`(`ScheduleId` ASC) USING BTREE,
  CONSTRAINT `batchid` FOREIGN KEY (`BatchId`) REFERENCES `batch` (`BatchId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`MajorId`) REFERENCES `major` (`MajorId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `student_ibfk_2` FOREIGN KEY (`ScheduleId`) REFERENCES `schedule` (`ScheduleId`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `初始分取值范围` CHECK ((`InitialTestScore` >= 0) and (`InitialTestScore` <= 100))
) ENGINE = InnoDB AUTO_INCREMENT = 2022101899 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of student
-- ----------------------------
INSERT INTO `student` VALUES (2022101895, '陈俊杰', '男', '暨南大学', 1, '未录取', 1, 100, 1, '18929115532');
INSERT INTO `student` VALUES (2022101896, '莫谦', '男', '暨南大学', 1, '笔试完成', 1, 100, 1, '15817618354');
INSERT INTO `student` VALUES (2022101898, '林志康', '男', '暨南大学', 1, '已录取', 1, 100, 1, '12345678');

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
  `Contact` int NOT NULL,
  `isPolitics` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`TeacherId`) USING BTREE,
  INDEX `DepartmentId`(`DepartmentId` ASC) USING BTREE,
  CONSTRAINT `teacher_ibfk_1` FOREIGN KEY (`DepartmentId`) REFERENCES `department` (`DepartmentId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of teacher
-- ----------------------------
INSERT INTO `teacher` VALUES (1, '里涡阳', '男', 1, '讲师', 123456789, 0);
INSERT INTO `teacher` VALUES (2, '冯家辉', '男', 1, '教授', 12345678, 1);
INSERT INTO `teacher` VALUES (3, '曹厚泽', '男', 1, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (4, '张世豪', '男', 1, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (5, '韩烨', '男', 1, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (6, '中维系', '男', 1, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (7, '逼格多动', '男', 2, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (8, '离谱', '男', 2, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (9, '状态值', '男', 2, '教授', 12345678, 1);
INSERT INTO `teacher` VALUES (10, '小河', '男', 2, '教授', 12345678, 0);
INSERT INTO `teacher` VALUES (11, '秀珍', '女', 2, '教授', 12345678, 0);

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
INSERT INTO `user` VALUES (1, 'Worker', 'dkp', '1', '2024-12-14 23:19:10', '1017975495@qq.com');
INSERT INTO `user` VALUES (2, 'Admin', 'dkpzi', '1', '2024-12-14 22:52:18', '1@qq.com');
INSERT INTO `user` VALUES (3, 'Admin', 'Aimer', 'Aimer', '2024-12-19 15:15:25', 'aimer@qq.com');
INSERT INTO `user` VALUES (4, 'Admin', 'dyj', '1', '2024-12-19 15:15:28', '1453983805@qq.com');

-- ----------------------------
-- Table structure for weight
-- ----------------------------
DROP TABLE IF EXISTS `weight`;
CREATE TABLE `weight`  (
  `WeightId` int NOT NULL AUTO_INCREMENT,
  `WeightName` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `Weight` double NOT NULL,
  PRIMARY KEY (`WeightId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of weight
-- ----------------------------
INSERT INTO `weight` VALUES (1, '初试权重', 0.7);
INSERT INTO `weight` VALUES (2, '复试笔试权重', 0.2);
INSERT INTO `weight` VALUES (3, '复试面试政治分权重', 0.5);
INSERT INTO `weight` VALUES (4, '复试面试其他权重', 0.5);
INSERT INTO `weight` VALUES (5, '复试面试权重', 0.1);
INSERT INTO `weight` VALUES (6, '通过分数', 60);

-- ----------------------------
-- Table structure for writtentestscore
-- ----------------------------
DROP TABLE IF EXISTS `writtentestscore`;
CREATE TABLE `writtentestscore`  (
  `WrittenTestScoreId` int NOT NULL AUTO_INCREMENT,
  `StudentId` int NULL DEFAULT NULL,
  `Score` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`WrittenTestScoreId`) USING BTREE,
  INDEX `StudentId`(`StudentId` ASC) USING BTREE,
  CONSTRAINT `writtentestscore_ibfk_1` FOREIGN KEY (`StudentId`) REFERENCES `student` (`StudentId`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 84 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of writtentestscore
-- ----------------------------
INSERT INTO `writtentestscore` VALUES (1, NULL, 100);
INSERT INTO `writtentestscore` VALUES (2, 2022101896, 60);
INSERT INTO `writtentestscore` VALUES (3, 2022101898, 90);
INSERT INTO `writtentestscore` VALUES (4, 2022101895, 100);

-- ----------------------------
-- View structure for interviewscore_view
-- ----------------------------
DROP VIEW IF EXISTS `interviewscore_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `interviewscore_view` AS select `i`.`InterviewScoreId` AS `InterviewScoreId`,`i`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`i`.`TeacherId` AS `TeacherId`,`t`.`TeacherName` AS `TeacherName`,`i`.`Score1` AS `Score1`,`i`.`Score2` AS `Score2`,`i`.`Score3` AS `Score3`,`b`.`Batch` AS `Batch` from (((`interviewscore` `i` join `student` `s` on((`i`.`StudentId` = `s`.`StudentId`))) join `teacher` `t` on((`i`.`TeacherId` = `t`.`TeacherId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`)));

-- ----------------------------
-- View structure for major_view
-- ----------------------------
DROP VIEW IF EXISTS `major_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `major_view` AS select `m`.`MajorId` AS `MajorId`,`m`.`MajorName` AS `MajorName`,`d`.`DepartmentName` AS `DepartmentName` from (`major` `m` join `department` `d` on((`m`.`DepartmentId` = `d`.`DepartmentId`)));

-- ----------------------------
-- View structure for schedule_view
-- ----------------------------
DROP VIEW IF EXISTS `schedule_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `schedule_view` AS select `sc`.`ScheduleId` AS `ScheduleId`,`c`.`ClassroomName` AS `ClassroomName`,`b`.`Batch` AS `Batch`,`sc`.`Teacher1Id` AS `Teacher1Id`,`sc`.`Teacher2Id` AS `Teacher2Id`,`sc`.`Teacher3Id` AS `Teacher3Id`,`sc`.`Teacher4Id` AS `Teacher4Id`,`sc`.`Teacher5Id` AS `Teacher5Id`,`t1`.`TeacherName` AS `Teacher1Name`,`t2`.`TeacherName` AS `Teacher2Name`,`t3`.`TeacherName` AS `Teacher3Name`,`t4`.`TeacherName` AS `Teacher4Name`,`t5`.`TeacherName` AS `Teacher5Name`,`sc`.`StartTime` AS `StartTime`,`sc`.`EndTime` AS `EndTime`,`sc`.`Datetime` AS `Datetime` from (((((((`schedule` `sc` join `classroom` `c` on((`sc`.`ClassroomId` = `c`.`ClassroomId`))) join `batch` `b` on((`sc`.`BatchId` = `b`.`BatchId`))) join `teacher` `t1` on((`sc`.`Teacher1Id` = `t1`.`TeacherId`))) join `teacher` `t2` on((`sc`.`Teacher2Id` = `t2`.`TeacherId`))) join `teacher` `t3` on((`sc`.`Teacher3Id` = `t3`.`TeacherId`))) join `teacher` `t4` on((`sc`.`Teacher4Id` = `t4`.`TeacherId`))) join `teacher` `t5` on((`sc`.`Teacher5Id` = `t5`.`TeacherId`)));

-- ----------------------------
-- View structure for student_view
-- ----------------------------
DROP VIEW IF EXISTS `student_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `student_view` AS select `s`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`s`.`Gender` AS `Gender`,`s`.`University` AS `University`,`s`.`Contact` AS `Contact`,`m`.`MajorName` AS `MajorName`,`s`.`Status` AS `Status`,`b`.`Batch` AS `Batch`,`s`.`InitialTestScore` AS `InitialTestScore`,`s`.`ScheduleId` AS `ScheduleId`,`c`.`ClassroomName` AS `ClassroomName`,`sc`.`Datetime` AS `Datetime` from ((((`student` `s` join `major` `m` on((`s`.`MajorId` = `m`.`MajorId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`))) join `schedule` `sc` on((`s`.`ScheduleId` = `sc`.`ScheduleId`))) join `classroom` `c` on((`sc`.`ClassroomId` = `c`.`ClassroomId`)));

-- ----------------------------
-- View structure for teacher_view
-- ----------------------------
DROP VIEW IF EXISTS `teacher_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `teacher_view` AS select `t`.`TeacherId` AS `TeacherId`,`t`.`TeacherName` AS `TeacherName`,`t`.`Gender` AS `Gender`,`d`.`DepartmentName` AS `DepartmentName`,`t`.`Title` AS `Title`,`t`.`Contact` AS `Contact`,`t`.`isPolitics` AS `isPolitics` from (`teacher` `t` join `department` `d` on((`t`.`DepartmentId` = `d`.`DepartmentId`)));

-- ----------------------------
-- View structure for writtentestscore_view
-- ----------------------------
DROP VIEW IF EXISTS `writtentestscore_view`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `writtentestscore_view` AS select `w`.`WrittenTestScoreId` AS `WrittenTestScoreId`,`w`.`StudentId` AS `StudentId`,`s`.`StudentName` AS `StudentName`,`w`.`Score` AS `Score`,`b`.`Batch` AS `Batch` from ((`writtentestscore` `w` join `student` `s` on((`s`.`StudentId` = `w`.`StudentId`))) join `batch` `b` on((`s`.`BatchId` = `b`.`BatchId`)));

-- ----------------------------
-- View structure for 总分表
-- ----------------------------
DROP VIEW IF EXISTS `总分表`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `总分表` AS select `batch`.`Batch` AS `Batch`,`department`.`DepartmentName` AS `DepartmentName`,`major`.`MajorName` AS `MajorName`,`student`.`StudentId` AS `StudentId`,`student`.`StudentName` AS `StudentName`,`student`.`InitialTestScore` AS `初试分`,`writtentestscore`.`Score` AS `笔试分`,`politescore`.`面试政治分` AS `面试政治分`,`elsescore`.`面试其他分` AS `面试其他分`,((`weight1`.`w3` * `politescore`.`面试政治分`) + (`weight1`.`w4` * `elsescore`.`面试其他分`)) AS `面试总分`,round((((`weight1`.`w1` * `student`.`InitialTestScore`) + (`weight1`.`w2` * `writtentestscore`.`Score`)) + (`weight1`.`w5` * ((`weight1`.`w3` * `politescore`.`面试政治分`) + (`weight1`.`w4` * `elsescore`.`面试其他分`)))),2) AS `总分`,(case when (round((((`weight1`.`w1` * `student`.`InitialTestScore`) + (`weight1`.`w2` * `writtentestscore`.`Score`)) + (`weight1`.`w5` * ((`weight1`.`w3` * `politescore`.`面试政治分`) + (`weight1`.`w4` * `elsescore`.`面试其他分`)))),2) >= `weight1`.`w6`) then 'Yes' else 'No' end) AS `是否通过` from (((((((`student` join `batch` on((`student`.`BatchId` = `batch`.`BatchId`))) join `major` on((`major`.`MajorId` = `student`.`MajorId`))) join `department` on((`major`.`DepartmentId` = `department`.`DepartmentId`))) join `writtentestscore` on((`student`.`StudentId` = `writtentestscore`.`StudentId`))) join (select `interviewscore`.`StudentId` AS `StudentId`,((`interviewscore`.`Score1` + `interviewscore`.`Score2`) + `interviewscore`.`Score3`) AS `面试政治分` from (`interviewscore` join `teacher` on((`interviewscore`.`TeacherId` = `teacher`.`TeacherId`))) where (`teacher`.`isPolitics` = 1)) `politescore` on((`student`.`StudentId` = `politescore`.`StudentId`))) join (select `interviewscore`.`StudentId` AS `StudentId`,((avg(`interviewscore`.`Score1`) + avg(`interviewscore`.`Score2`)) + avg(`interviewscore`.`Score3`)) AS `面试其他分` from (`interviewscore` join `teacher` on((`interviewscore`.`TeacherId` = `teacher`.`TeacherId`))) where (`teacher`.`isPolitics` = 0) group by `interviewscore`.`StudentId`) `elsescore` on((`student`.`StudentId` = `elsescore`.`StudentId`))) join (select max((case when (`weight`.`WeightName` = '初试权重') then `weight`.`Weight` end)) AS `w1`,max((case when (`weight`.`WeightName` = '复试笔试权重') then `weight`.`Weight` end)) AS `w2`,max((case when (`weight`.`WeightName` = '复试面试政治分权重') then `weight`.`Weight` end)) AS `w3`,max((case when (`weight`.`WeightName` = '复试面试其他权重') then `weight`.`Weight` end)) AS `w4`,max((case when (`weight`.`WeightName` = '复试面试权重') then `weight`.`Weight` end)) AS `w5`,max((case when (`weight`.`WeightName` = '通过分数') then `weight`.`Weight` end)) AS `w6` from `weight`) `weight1` on((1 = 1)));


-- ----------------------------
-- View structure for 专业平均分表
-- ----------------------------
DROP VIEW IF EXISTS `专业平均分表`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `专业平均分表` AS select `总分表`.`Batch` AS `Batch`,`总分表`.`DepartmentName` AS `DepartmentName`,`总分表`.`MajorName` AS `MajorName`,avg(`总分表`.`初试分`) AS `平均初试分`,avg(`总分表`.`面试政治分`) AS `平均政治分`,avg(`总分表`.`面试其他分`) AS `平均其他分`,avg(`总分表`.`面试总分`) AS `平均面试总分`,avg(`总分表`.`总分`) AS `平均总分` from `总分表` group by `总分表`.`Batch`,`总分表`.`MajorName`,`总分表`.`DepartmentName`;

-- ----------------------------
-- View structure for 专业录取率表
-- ----------------------------
DROP VIEW IF EXISTS `专业录取率表`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `专业录取率表` AS select `student_status`.`Batch` AS `Batch`,`departmentmajor`.`DepartmentName` AS `DepartmentName`,`departmentmajor`.`MajorName` AS `MajorName`,`student_status`.`录取率` AS `录取率` from ((select `student`.`MajorId` AS `MajorId`,`student`.`BatchId` AS `BatchId`,`batch`.`Batch` AS `Batch`,concat((round((sum((`student`.`Status` = '已录取')) / (sum((`student`.`Status` = '已录取')) + sum((`student`.`Status` = '未录取')))),2) * 100),'%') AS `录取率` from (`student` join `batch` on((`student`.`BatchId` = `batch`.`BatchId`))) group by `student`.`MajorId`,`batch`.`BatchId`) `student_status` join (select `major`.`MajorId` AS `MajorId`,`major`.`MajorName` AS `MajorName`,`department`.`DepartmentName` AS `DepartmentName` from (`major` join `department` on((`major`.`DepartmentId` = `department`.`DepartmentId`)))) `departmentmajor` on((`student_status`.`MajorId` = `departmentmajor`.`MajorId`))) where (`student_status`.`录取率` is not null);

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `学院的名称不能重复——插入`;
delimiter ;;
CREATE TRIGGER `学院的名称不能重复——插入` BEFORE INSERT ON `department` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM department d
		WHERE d.DepartmentName = NEW.DepartmentName
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '学院名称重复';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table department
-- ----------------------------
DROP TRIGGER IF EXISTS `学院的名称不能重复——更新`;
delimiter ;;
CREATE TRIGGER `学院的名称不能重复——更新` BEFORE UPDATE ON `department` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM department d
		WHERE d.DepartmentName = NEW.DepartmentName AND OLD.DepartmentId != d.DepartmentId
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '学院名称重复';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `只有当笔试通过了才能填写面试的`;
delimiter ;;
CREATE TRIGGER `只有当笔试通过了才能填写面试的` BEFORE INSERT ON `interviewscore` FOR EACH ROW BEGIN
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
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `只能输入给你打分的那个老师`;
delimiter ;;
CREATE TRIGGER `只能输入给你打分的那个老师` BEFORE INSERT ON `interviewscore` FOR EACH ROW BEGIN
	DECLARE t1id INT;
	DECLARE t2id INT;
	DECLARE t3id INT;
	DECLARE t4id INT;
	DECLARE t5id INT;
	DECLARE scheduleid INT;

	-- 获取学生的 ScheduleId
	SELECT student.ScheduleId INTO scheduleid 
	FROM student 
	WHERE NEW.StudentId = student.StudentId;

	-- 获取教师 ID
	SELECT Teacher1Id, Teacher2Id, Teacher3Id, Teacher4Id, Teacher5Id
	INTO t1id, t2id, t3id, t4id, t5id
	FROM `schedule` sc 
	WHERE sc.ScheduleId = scheduleid;

	-- 判断教师是否未评分
	IF NEW.TeacherId != t1id AND NEW.TeacherId != t2id AND NEW.TeacherId != t3id AND NEW.TeacherId != t4id AND NEW.TeacherId != t5id THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '该老师未给学生评分';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `一个老师只能打一次分——插入`;
delimiter ;;
CREATE TRIGGER `一个老师只能打一次分——插入` BEFORE INSERT ON `interviewscore` FOR EACH ROW BEGIN
	IF EXISTS(
		SELECT *
		FROM interviewscore
		WHERE interviewscore.StudentId = NEW.StudentId AND interviewscore.TeacherId = NEW.TeacherId
	)THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '该老师已经评过分了';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `面试超过5条则为评分完成`;
delimiter ;;
CREATE TRIGGER `面试超过5条则为评分完成` AFTER INSERT ON `interviewscore` FOR EACH ROW BEGIN
	DECLARE count_num INT;
	SELECT COUNT(*) INTO count_num
	FROM interviewscore i
	WHERE i.StudentId = NEW.StudentId;
	
	IF count_num = 5 THEN
		UPDATE student s
		SET s.Status = '面试完成'
		WHERE s.StudentId = NEW.StudentId;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `更新只能输入给你打分的老师`;
delimiter ;;
CREATE TRIGGER `更新只能输入给你打分的老师` BEFORE UPDATE ON `interviewscore` FOR EACH ROW BEGIN
	DECLARE t1id INT;
	DECLARE t2id INT;
	DECLARE t3id INT;
	DECLARE t4id INT;
	DECLARE t5id INT;
	DECLARE scheduleid INT;

	-- 获取学生的 ScheduleId
	SELECT student.ScheduleId INTO scheduleid 
	FROM student 
	WHERE NEW.StudentId = student.StudentId;

	-- 获取教师 ID
	SELECT Teacher1Id, Teacher2Id, Teacher3Id, Teacher4Id, Teacher5Id
	INTO t1id, t2id, t3id, t4id, t5id
	FROM `schedule` sc 
	WHERE sc.ScheduleId = scheduleid;

	-- 判断教师是否未评分
	IF NEW.TeacherId != t1id AND NEW.TeacherId != t2id AND NEW.TeacherId != t3id AND NEW.TeacherId != t4id AND NEW.TeacherId != t5id THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '该老师未给学生评分';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table interviewscore
-- ----------------------------
DROP TRIGGER IF EXISTS `一个老师只能打一次份——更新`;
delimiter ;;
CREATE TRIGGER `一个老师只能打一次份——更新` BEFORE UPDATE ON `interviewscore` FOR EACH ROW BEGIN
	DECLARE num INT DEFAULT 0;
	DECLARE existing_id INT DEFAULT NULL;
	
	SELECT COUNT(*) INTO num
	FROM interviewscore
	WHERE interviewscore.StudentId = NEW.StudentId AND interviewscore.TeacherId = NEW.TeacherId AND OLD.InterviewScoreId != interviewscore.InterviewScoreId;

	IF num > 0 THEN
		SELECT InterviewScoreId INTO existing_id
		FROM interviewscore
		WHERE interviewscore.StudentId = NEW.StudentId AND interviewscore.TeacherId = NEW.TeacherId
		LIMIT 1;
	END IF;

	-- 检查是否重复评分
	IF num = 1 AND existing_id != NEW.InterviewScoreId THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = '该老师已经评过分了';
	END IF;

END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table major
-- ----------------------------
DROP TRIGGER IF EXISTS `专业的名称不能重复——插入`;
delimiter ;;
CREATE TRIGGER `专业的名称不能重复——插入` BEFORE INSERT ON `major` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM major
		WHERE major.MajorName = NEW.MajorName
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '专业名称重复';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table major
-- ----------------------------
DROP TRIGGER IF EXISTS `专业的名称不能重复——更新`;
delimiter ;;
CREATE TRIGGER `专业的名称不能重复——更新` BEFORE UPDATE ON `major` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM major m
		WHERE m.MajorName = NEW.MajorName AND OLD.MajorId != m.MajorId
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '专业名称重复';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `第一个老师是政治老师——插入`;
delimiter ;;
CREATE TRIGGER `第一个老师是政治老师——插入` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
	DECLARE ispolitics INT;
	SELECT teacher.isPolitics INTO ispolitics
	FROM teacher
	WHERE teacher.TeacherId = NEW.Teacher1Id;
	IF ispolitics != 1 THEN
		SIGNAL SQLSTATE '45000'
	  SET MESSAGE_TEXT = '该位老师不是政治老师';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `排班冲突——插入`;
delimiter ;;
CREATE TRIGGER `排班冲突——插入` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT * 
		FROM schedule s
		WHERE s.ClassroomId = NEW.ClassroomId AND s.Datetime = NEW.Datetime 
			AND NOT (NEW.EndTime <= s.StartTime OR NEW.StartTime >= s.EndTime)
	)THEN
		SIGNAL SQLSTATE "45000"
		SET message_text = '排班时间冲突';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `本身时间冲突——插入`;
delimiter ;;
CREATE TRIGGER `本身时间冲突——插入` BEFORE INSERT ON `schedule` FOR EACH ROW BEGIN 
	IF NEW.StartTime >= NEW.EndTime THEN
		SIGNAL SQLSTATE "45000"
		SET message_text = "开始时间比结束时间晚";
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `第一个老师是政治老师——更新`;
delimiter ;;
CREATE TRIGGER `第一个老师是政治老师——更新` BEFORE UPDATE ON `schedule` FOR EACH ROW BEGIN
	DECLARE ispolitics INT;
	SELECT teacher.isPolitics INTO ispolitics
	FROM teacher
	WHERE teacher.TeacherId = NEW.Teacher1Id;
	IF ispolitics != 1 THEN
		SIGNAL SQLSTATE '45000'
	  SET MESSAGE_TEXT = '该位老师不是政治老师';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `排班冲突——更新`;
delimiter ;;
CREATE TRIGGER `排班冲突——更新` BEFORE UPDATE ON `schedule` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT * 
		FROM schedule s
		WHERE s.ClassroomId = NEW.ClassroomId 
			AND s.Datetime = NEW.Datetime 
			AND NOT (NEW.EndTime <= s.StartTime OR NEW.StartTime >= s.EndTime)
			AND OLD.ScheduleId != s.ScheduleId
	)THEN
		SIGNAL SQLSTATE "45000"
		SET message_text = NEW.ScheduleId;
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table schedule
-- ----------------------------
DROP TRIGGER IF EXISTS `本身时间冲突——更新`;
delimiter ;;
CREATE TRIGGER `本身时间冲突——更新` BEFORE UPDATE ON `schedule` FOR EACH ROW BEGIN 
	IF NEW.StartTime >= NEW.EndTime THEN
		SIGNAL SQLSTATE "45000"
		SET message_text = "开始时间比结束时间晚";
	END IF;
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
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `用户名不能重复——插入`;
delimiter ;;
CREATE TRIGGER `用户名不能重复——插入` BEFORE INSERT ON `user` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM user u
		WHERE u.Account = NEW.Account
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '用户名称重复';
	END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table user
-- ----------------------------
DROP TRIGGER IF EXISTS `用户名不能重复——更新`;
delimiter ;;
CREATE TRIGGER `用户名不能重复——更新` BEFORE UPDATE ON `user` FOR EACH ROW BEGIN
	IF EXISTS (
		SELECT *
		FROM user u
		WHERE u.Account = NEW.Account AND OLD.UserId != u.UserId
	)THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = '用户名称重复';
	END IF;
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
