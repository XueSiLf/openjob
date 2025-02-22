# Dump of table app
# ------------------------------------------------------------

DROP TABLE IF EXISTS `app`;

CREATE TABLE `app` (
                       `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                       `namespace_id` bigint(20) NOT NULL,
                       `name` varchar(256) NOT NULL DEFAULT '',
                       `desc` varchar(256) NOT NULL DEFAULT '',
                       `create_time` int(11) NOT NULL,
                       `update_time` int(11) NOT NULL,
                       PRIMARY KEY (`id`),
                       UNIQUE KEY `udx_app_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `app` WRITE;
/*!40000 ALTER TABLE `app` DISABLE KEYS */;

INSERT INTO `app` (`id`, `namespace_id`, `name`, `desc`, `create_time`, `update_time`)
VALUES
    (1,1,'openjob','openjob',1658473199,1658473199);

/*!40000 ALTER TABLE `app` ENABLE KEYS */;
UNLOCK TABLES;



# Dump of table delay
# ------------------------------------------------------------

DROP TABLE IF EXISTS `delay`;

CREATE TABLE `delay` (
                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                         `namespace_id` bigint(20) NOT NULL,
                         `app_id` bigint(20) NOT NULL,
                         `name` varchar(128) NOT NULL DEFAULT '',
                         `description` varchar(256) NOT NULL DEFAULT '',
                         `processor_info` varchar(256) NOT NULL DEFAULT '',
                         `fail_retry_times` int(11) NOT NULL DEFAULT '0',
                         `fail_retry_interval` int(11) NOT NULL DEFAULT '1000',
                         `status` int(11) NOT NULL DEFAULT '1',
                         `execute_timeout` int(11) NOT NULL DEFAULT '0',
                         `concurrency` int(11) NOT NULL DEFAULT '2',
                         `blocking_size` int(11) NOT NULL DEFAULT '20',
                         `topic` varchar(128) NOT NULL DEFAULT '',
                         `create_time` int(11) NOT NULL,
                         `update_time` int(11) NOT NULL,
                         PRIMARY KEY (`id`),
                         KEY `udx_topic` (`topic`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table delay_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `delay_instance`;

CREATE TABLE `delay_instance` (
                                  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                  `app_id` bigint(20) NOT NULL,
                                  `namespace_id` bigint(20) NOT NULL,
                                  `task_id` varchar(64) NOT NULL DEFAULT '',
                                  `topic` varchar(128) NOT NULL DEFAULT '',
                                  `delay_id` bigint(20) NOT NULL,
                                  `delay_params` longtext NOT NULL,
                                  `delay_extra` text NOT NULL,
                                  `status` tinyint(2) NOT NULL,
                                  `slots_id` bigint(20) NOT NULL,
                                  `execute_time` int(11) NOT NULL,
                                  `create_time` int(11) NOT NULL,
                                  `update_time` int(11) NOT NULL,
                                  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table delay_worker
# ------------------------------------------------------------

DROP TABLE IF EXISTS `delay_worker`;

CREATE TABLE `delay_worker` (
                                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                `topic` varchar(128) NOT NULL DEFAULT '',
                                `pull_size` int(11) NOT NULL DEFAULT '0',
                                `pull_time` bigint(16) NOT NULL DEFAULT '0',
                                `create_time` int(11) NOT NULL,
                                `update_time` int(11) NOT NULL,
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job`;

CREATE TABLE `job` (
                       `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                       `namespace_id` bigint(20) NOT NULL,
                       `app_id` bigint(20) NOT NULL,
                       `workflow_id` bigint(20) NOT NULL DEFAULT '0',
                       `name` varchar(32) NOT NULL DEFAULT '',
                       `description` varchar(128) NOT NULL DEFAULT '',
                       `processor_type` varchar(16) NOT NULL DEFAULT 'java' COMMENT 'java /shell/python',
                       `processor_info` varchar(128) NOT NULL DEFAULT '',
                       `execute_type` varchar(16) NOT NULL DEFAULT 'standalone' COMMENT 'execute type 1=standalone 2=broadcast 3=MR',
                       `params` varchar(3096) NOT NULL DEFAULT '',
                       `fail_retry_times` int(11) NOT NULL,
                       `fail_retry_interval` int(11) NOT NULL,
                       `concurrency` int(11) NOT NULL DEFAULT '1',
                       `time_expression_type` varchar(16) NOT NULL DEFAULT 'cron' COMMENT 'cron/second/delay',
                       `time_expression` varchar(32) NOT NULL DEFAULT '' COMMENT 'Cron express type',
                       `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT '1=running 2=stop',
                       `next_execute_time` int(11) NOT NULL,
                       `slots_id` int(11) NOT NULL,
                       `create_time` int(11) NOT NULL,
                       `update_time` int(11) NOT NULL,
                       PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;

INSERT INTO `job` (`id`, `namespace_id`, `app_id`, `workflow_id`, `name`, `description`, `processor_type`, `processor_info`, `execute_type`, `params`, `fail_retry_times`, `fail_retry_interval`, `concurrency`, `time_expression_type`, `time_expression`, `status`, `next_execute_time`, `slots_id`, `create_time`, `update_time`)
VALUES
    (10,1,1,0,'测试任务','测试任务','java','io.openjob.worker.samples.processor.JavaProcessorSample','standalone','',0,0,1,'cron','30 * * * * ?',2,1663590330,15874,1657528102,1663590220),
    (13,1,1,0,'测试任务2','测试任务2','java','io.openjob.worker.samples.processorJavaProcessorSample','standalone','',0,0,1,'cron','10 * * * * ?',2,1660288630,1,1657528102,1660288512),
    (14,1,1,0,'测试任务','测试任务','java','io.openjob.worker.samples.processor.JavaProcessorSample','standalone','',0,0,1,'cron','59 * * * * ?',2,1660288619,1024,1657528102,1660288512),
    (15,1,1,0,'测试任务','测试任务','java','io.openjob.worker.samples.processor.JavaProcessorSample','standalone','',0,0,1,'cron','0 */3 * * * ?',2,1660288680,10074,1657528102,1660288452),
    (16,1,1,0,'MR任务测试','测试MR','java','io.openjob.worker.samples.processor.MapReduceProcessorSample','mapReduce','',0,0,1,'cron','15 * * * * ?',1,1666100115,2321,1657528102,1666099995);

/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table job_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_instance`;

CREATE TABLE `job_instance` (
                                `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                `job_id` bigint(20) NOT NULL,
                                `job_params` varchar(3096) NOT NULL,
                                `status` tinyint(11) NOT NULL DEFAULT '1',
                                `slots_id` bigint(20) NOT NULL,
                                `namespace_id` bigint(20) NOT NULL,
                                `app_id` bigint(20) NOT NULL,
                                `execute_time` int(11) NOT NULL,
                                `complete_time` int(11) NOT NULL DEFAULT '0',
                                `last_report_time` int(11) NOT NULL DEFAULT '0',
                                `update_time` int(11) NOT NULL,
                                `create_time` int(11) NOT NULL,
                                PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table job_instance_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_instance_log`;

CREATE TABLE `job_instance_log` (
                                    `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                    `job_id` bigint(20) NOT NULL,
                                    `job_instance_id` bigint(20) NOT NULL,
                                    `message` longtext,
                                    `create_time` int(11) NOT NULL,
                                    `update_time` int(11) DEFAULT NULL,
                                    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

# Dump of table job_instance_task
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_instance_task`;

CREATE TABLE `job_instance_task` (
                                     `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                                     `job_id` bigint(20) NOT NULL,
                                     `job_instance_id` bigint(20) NOT NULL,
                                     `circle_id` bigint(20) NOT NULL,
                                     `task_id` varchar(64) NOT NULL DEFAULT '',
                                     `parent_task_id` varchar(64) NOT NULL DEFAULT '0',
                                     `task_name` varchar(128) NOT NULL DEFAULT '',
                                     `status` tinyint(2) NOT NULL DEFAULT '1',
                                     `result` longtext,
                                     `worker_address` varchar(128) NOT NULL DEFAULT '',
                                     `create_time` int(11) DEFAULT NULL,
                                     `update_time` int(11) DEFAULT NULL,
                                     PRIMARY KEY (`id`),
                                     UNIQUE KEY `udx_task_id` (`task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table job_instance_task_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_instance_task_log`;

CREATE TABLE `job_instance_task_log` (
                                         `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                         `job_id` bigint(20) NOT NULL,
                                         `job_instance_id` bigint(20) NOT NULL,
                                         `circle_id` bigint(20) NOT NULL,
                                         `task_id` bigint(20) NOT NULL,
                                         `task_unique_id` varchar(64) NOT NULL DEFAULT '',
                                         `worker_address` varchar(128) NOT NULL DEFAULT '',
                                         `content` longtext NOT NULL,
                                         `time` bigint(16) NOT NULL,
                                         PRIMARY KEY (`id`),
                                         KEY `idx_task_unique_id_time` (`task_unique_id`,`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table job_slots
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_slots`;

CREATE TABLE `job_slots` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `server_id` bigint(20) NOT NULL,
                             `create_time` int(11) NOT NULL,
                             `update_time` int(11) NOT NULL,
                             PRIMARY KEY (`id`),
                             KEY `idx_server_id` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `job_slots` WRITE;
/*!40000 ALTER TABLE `job_slots` DISABLE KEYS */;

INSERT INTO `job_slots` (`id`, `server_id`, `create_time`, `update_time`)
VALUES
    (1,0,1655781998,1666100014),
    (2,0,1655781999,1666100014),
    (3,0,1655781999,1666100014),
    (4,0,1655781999,1666100014),
    (5,0,1655781999,1666100014),
    (6,0,1655781999,1666100014),
    (7,0,1655781999,1666100014),
    (8,0,1655781999,1666100014),
    (9,0,1655781999,1666100014),
    (10,0,1655781999,1666100014),
    (11,0,1655781999,1666100014),
    (12,0,1655781999,1666100014),
    (13,0,1655781999,1666100014),
    (14,0,1655781999,1666100014),
    (15,0,1655781999,1666100014),
    (16,0,1655781999,1666100014),
    (17,0,1655781999,1666100014),
    (18,0,1655781999,1666100014),
    (19,0,1655781999,1666100014),
    (20,0,1655781999,1666100014),
    (21,0,1655781999,1666100014),
    (22,0,1655781999,1666100014),
    (23,0,1655781999,1666100014),
    (24,0,1655781999,1666100014),
    (25,0,1655781999,1666100014),
    (26,0,1655781999,1666100014),
    (27,0,1655781999,1666100014),
    (28,0,1655781999,1666100014),
    (29,0,1655781999,1666100014),
    (30,0,1655781999,1666100014),
    (31,0,1655781999,1666100014),
    (32,0,1655781999,1666100014),
    (33,0,1655781999,1666100014),
    (34,0,1655781999,1666100014),
    (35,0,1655781999,1666100014),
    (36,0,1655781999,1666100014),
    (37,0,1655781999,1666100014),
    (38,0,1655781999,1666100014),
    (39,0,1655781999,1666100014),
    (40,0,1655781999,1666100014),
    (41,0,1655781999,1666100014),
    (42,0,1655781999,1666100014),
    (43,0,1655781999,1666100014),
    (44,0,1655781999,1666100014),
    (45,0,1655781999,1666100014),
    (46,0,1655781999,1666100014),
    (47,0,1655781999,1666100014),
    (48,0,1655781999,1666100014),
    (49,0,1655781999,1666100014),
    (50,0,1655781999,1666100014),
    (51,0,1655781999,1666100014),
    (52,0,1655781999,1666100014),
    (53,0,1655781999,1666100014),
    (54,0,1655781999,1666100014),
    (55,0,1655781999,1666100014),
    (56,0,1655781999,1666100014),
    (57,0,1655781999,1666100014),
    (58,0,1655781999,1666100014),
    (59,0,1655781999,1666100014),
    (60,0,1655781999,1666100014),
    (61,0,1655781999,1666100014),
    (62,0,1655781999,1666100014),
    (63,0,1655781999,1666100014),
    (64,0,1655781999,1666100014),
    (65,0,1655781999,1666100014),
    (66,0,1655781999,1666100014),
    (67,0,1655781999,1666100014),
    (68,0,1655781999,1666100014),
    (69,0,1655781999,1666100014),
    (70,0,1655781999,1666100014),
    (71,0,1655781999,1666100014),
    (72,0,1655781999,1666100014),
    (73,0,1655781999,1666100014),
    (74,0,1655781999,1666100014),
    (75,0,1655781999,1666100014),
    (76,0,1655781999,1666100014),
    (77,0,1655781999,1666100014),
    (78,0,1655781999,1666100014),
    (79,0,1655781999,1666100014),
    (80,0,1655781999,1666100014),
    (81,0,1655781999,1666100014),
    (82,0,1655781999,1666100014),
    (83,0,1655781999,1666100014),
    (84,0,1655781999,1666100014),
    (85,0,1655781999,1666100014),
    (86,0,1655781999,1666100014),
    (87,0,1655781999,1666100014),
    (88,0,1655781999,1666100014),
    (89,0,1655781999,1666100014),
    (90,0,1655781999,1666100014),
    (91,0,1655781999,1666100014),
    (92,0,1655781999,1666100014),
    (93,0,1655781999,1666100014),
    (94,0,1655781999,1666100014),
    (95,0,1655781999,1666100014),
    (96,0,1655781999,1666100014),
    (97,0,1655781999,1666100014),
    (98,0,1655781999,1666100014),
    (99,0,1655781999,1666100014),
    (100,0,1655781999,1666100014),
    (101,0,1655781999,1666100014),
    (102,0,1655781999,1666100014),
    (103,0,1655781999,1666100014),
    (104,0,1655781999,1666100014),
    (105,0,1655781999,1666100014),
    (106,0,1655781999,1666100014),
    (107,0,1655781999,1666100014),
    (108,0,1655781999,1666100014),
    (109,0,1655781999,1666100014),
    (110,0,1655781999,1666100014),
    (111,0,1655781999,1666100014),
    (112,0,1655781999,1666100014),
    (113,0,1655781999,1666100014),
    (114,0,1655781999,1666100014),
    (115,0,1655781999,1666100014),
    (116,0,1655781999,1666100014),
    (117,0,1655781999,1666100014),
    (118,0,1655781999,1666100014),
    (119,0,1655781999,1666100014),
    (120,0,1655781999,1666100014),
    (121,0,1655781999,1666100014),
    (122,0,1655781999,1666100014),
    (123,0,1655781999,1666100014),
    (124,0,1655781999,1666100014),
    (125,0,1655781999,1666100014),
    (126,0,1655781999,1666100014),
    (127,0,1655781999,1666100014),
    (128,0,1655781999,1666100014),
    (129,0,1655781999,1666100014),
    (130,0,1655781999,1666100014),
    (131,0,1655781999,1666100014),
    (132,0,1655781999,1666100014),
    (133,0,1655781999,1666100014),
    (134,0,1655781999,1666100014),
    (135,0,1655781999,1666100014),
    (136,0,1655782000,1666100014),
    (137,0,1655782000,1666100014),
    (138,0,1655782000,1666100014),
    (139,0,1655782000,1666100014),
    (140,0,1655782000,1666100014),
    (141,0,1655782000,1666100014),
    (142,0,1655782000,1666100014),
    (143,0,1655782000,1666100014),
    (144,0,1655782000,1666100014),
    (145,0,1655782000,1666100014),
    (146,0,1655782000,1666100014),
    (147,0,1655782000,1666100014),
    (148,0,1655782000,1666100014),
    (149,0,1655782000,1666100014),
    (150,0,1655782000,1666100014),
    (151,0,1655782000,1666100014),
    (152,0,1655782000,1666100014),
    (153,0,1655782000,1666100014),
    (154,0,1655782000,1666100014),
    (155,0,1655782000,1666100014),
    (156,0,1655782000,1666100014),
    (157,0,1655782000,1666100014),
    (158,0,1655782000,1666100014),
    (159,0,1655782000,1666100014),
    (160,0,1655782000,1666100014),
    (161,0,1655782000,1666100014),
    (162,0,1655782000,1666100014),
    (163,0,1655782000,1666100014),
    (164,0,1655782000,1666100014),
    (165,0,1655782000,1666100014),
    (166,0,1655782000,1666100014),
    (167,0,1655782000,1666100014),
    (168,0,1655782000,1666100014),
    (169,0,1655782000,1666100014),
    (170,0,1655782000,1666100014),
    (171,0,1655782000,1666100014),
    (172,0,1655782000,1666100014),
    (173,0,1655782000,1666100014),
    (174,0,1655782000,1666100014),
    (175,0,1655782000,1666100014),
    (176,0,1655782000,1666100014),
    (177,0,1655782000,1666100014),
    (178,0,1655782000,1666100014),
    (179,0,1655782000,1666100014),
    (180,0,1655782000,1666100014),
    (181,0,1655782000,1666100014),
    (182,0,1655782000,1666100014),
    (183,0,1655782000,1666100014),
    (184,0,1655782000,1666100014),
    (185,0,1655782000,1666100014),
    (186,0,1655782000,1666100014),
    (187,0,1655782000,1666100014),
    (188,0,1655782000,1666100014),
    (189,0,1655782000,1666100014),
    (190,0,1655782000,1666100014),
    (191,0,1655782000,1666100014),
    (192,0,1655782000,1666100014),
    (193,0,1655782000,1666100014),
    (194,0,1655782000,1666100014),
    (195,0,1655782000,1666100014),
    (196,0,1655782000,1666100014),
    (197,0,1655782000,1666100014),
    (198,0,1655782000,1666100014),
    (199,0,1655782000,1666100014),
    (200,0,1655782000,1666100014),
    (201,0,1655782000,1666100014),
    (202,0,1655782000,1666100014),
    (203,0,1655782000,1666100014),
    (204,0,1655782000,1666100014),
    (205,0,1655782000,1666100014),
    (206,0,1655782000,1666100014),
    (207,0,1655782000,1666100014),
    (208,0,1655782000,1666100014),
    (209,0,1655782000,1666100014),
    (210,0,1655782000,1666100014),
    (211,0,1655782000,1666100014),
    (212,0,1655782000,1666100014),
    (213,0,1655782000,1666100014),
    (214,0,1655782000,1666100014),
    (215,0,1655782000,1666100014),
    (216,0,1655782000,1666100014),
    (217,0,1655782000,1666100014),
    (218,0,1655782000,1666100014),
    (219,0,1655782000,1666100014),
    (220,0,1655782000,1666100014),
    (221,0,1655782000,1666100014),
    (222,0,1655782000,1666100014),
    (223,0,1655782000,1666100014),
    (224,0,1655782000,1666100014),
    (225,0,1655782000,1666100014),
    (226,0,1655782000,1666100014),
    (227,0,1655782000,1666100014),
    (228,0,1655782000,1666100014),
    (229,0,1655782000,1666100014),
    (230,0,1655782000,1666100014),
    (231,0,1655782000,1666100014),
    (232,0,1655782000,1666100014),
    (233,0,1655782000,1666100014),
    (234,0,1655782000,1666100014),
    (235,0,1655782000,1666100014),
    (236,0,1655782000,1666100014),
    (237,0,1655782000,1666100014),
    (238,0,1655782000,1666100014),
    (239,0,1655782000,1666100014),
    (240,0,1655782000,1666100014),
    (241,0,1655782000,1666100014),
    (242,0,1655782000,1666100014),
    (243,0,1655782000,1666100014),
    (244,0,1655782000,1666100014),
    (245,0,1655782000,1666100014),
    (246,0,1655782000,1666100014),
    (247,0,1655782000,1666100014),
    (248,0,1655782000,1666100014),
    (249,0,1655782000,1666100014),
    (250,0,1655782000,1666100014),
    (251,0,1655782000,1666100014),
    (252,0,1655782000,1666100014),
    (253,0,1655782000,1666100014),
    (254,0,1655782000,1666100014),
    (255,0,1655782000,1666100014),
    (256,0,1655782000,1666100014);

/*!40000 ALTER TABLE `job_slots` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table namespace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `namespace`;

CREATE TABLE `namespace` (
                             `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                             `name` varchar(64) NOT NULL DEFAULT '',
                             `desc` varchar(64) NOT NULL DEFAULT '',
                             `secret` varchar(64) NOT NULL DEFAULT '',
                             `status` tinyint(2) NOT NULL DEFAULT '1',
                             `create_time` bigint(12) NOT NULL,
                             `update_time` bigint(12) NOT NULL,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `udx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table server
# ------------------------------------------------------------

DROP TABLE IF EXISTS `server`;

CREATE TABLE `server` (
                          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'ID',
                          `ip` varchar(32) NOT NULL DEFAULT '' COMMENT 'Server ip',
                          `akka_address` varchar(32) NOT NULL DEFAULT '' COMMENT 'Akka adress like `127.0.0.1:25520`',
                          `status` tinyint(2) NOT NULL DEFAULT '1' COMMENT 'Server status 1=ok 2=fail',
                          `create_time` int(11) NOT NULL COMMENT 'Create time',
                          `update_time` int(11) NOT NULL COMMENT 'Update time',
                          PRIMARY KEY (`id`),
                          KEY `udx_akka_address` (`akka_address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table server_fail_reports
# ------------------------------------------------------------

DROP TABLE IF EXISTS `server_fail_reports`;

CREATE TABLE `server_fail_reports` (
                                       `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                                       `server_id` bigint(20) NOT NULL,
                                       `report_server_id` bigint(20) NOT NULL,
                                       `create_time` int(11) NOT NULL,
                                       PRIMARY KEY (`id`),
                                       KEY `idx_create_time_server_id` (`create_time`,`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



# Dump of table task
# ------------------------------------------------------------

DROP TABLE IF EXISTS `task`;

CREATE TABLE `task` (
                        `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                        `job_id` bigint(20) NOT NULL,
                        `instance_id` bigint(20) NOT NULL,
                        `circle_id` bigint(20) NOT NULL DEFAULT '0',
                        `task_id` varchar(64) NOT NULL DEFAULT '',
                        `task_name` varchar(128) NOT NULL,
                        `task_parent_id` varchar(64) NOT NULL DEFAULT '0',
                        `status` tinyint(2) NOT NULL DEFAULT '1',
                        `worker_address` varchar(32) NOT NULL DEFAULT '',
                        `result` longtext,
                        `task_body` blob,
                        `create_time` int(11) NOT NULL,
                        `update_time` int(11) NOT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `udx_task_id` (`task_id`),
                        KEY `idx_instance_id_circle_id` (`instance_id`,`circle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


# Dump of table worker
# ------------------------------------------------------------

DROP TABLE IF EXISTS `worker`;

CREATE TABLE `worker` (
                          `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
                          `app_id` bigint(20) NOT NULL,
                          `namespace_id` bigint(20) NOT NULL,
                          `app_name` varchar(128) NOT NULL DEFAULT '',
                          `worker_key` varchar(64) NOT NULL DEFAULT '',
                          `address` varchar(32) NOT NULL DEFAULT '',
                          `protocol_type` varchar(8) NOT NULL DEFAULT '',
                          `version` varchar(32) NOT NULL DEFAULT '',
                          `last_heartbeat_time` int(11) NOT NULL,
                          `status` tinyint(2) NOT NULL DEFAULT '1',
                          `metric` varchar(1024) NOT NULL DEFAULT '',
                          `create_time` int(11) NOT NULL,
                          `update_time` int(11) NOT NULL,
                          PRIMARY KEY (`id`),
                          KEY `udx_address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


# Dump of table system
# ------------------------------------------------------------
DROP TABLE IF EXISTS `system`;

CREATE TABLE `system` (
                          `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
                          `version` varchar(16) NOT NULL DEFAULT '0',
                          `cluster_version` bigint(12) NOT NULL DEFAULT '0',
                          `max_slot` int(11) DEFAULT '256',
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOCK TABLES `system` WRITE;
/*!40000 ALTER TABLE `system` DISABLE KEYS */;

INSERT INTO `system` (`id`, `version`, `cluster_version`, `max_slot`)
VALUES
    (1,'1.0.0',0,256);

/*!40000 ALTER TABLE `system` ENABLE KEYS */;
UNLOCK TABLES;
