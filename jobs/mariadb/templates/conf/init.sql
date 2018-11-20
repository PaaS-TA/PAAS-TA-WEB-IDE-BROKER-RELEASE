    UPDATE mysql.user SET password=PASSWORD('<%= p("mariadb.admin_user.password") %>') WHERE user='root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '<%= p("mariadb.admin_user.password") %>' WITH GRANT OPTION;
FLUSH PRIVILEGES;


CREATE DATABASE /*!32312 IF NOT EXISTS*/`webide` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `webide`;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for web_ide_info
-- ----------------------------
DROP TABLE IF EXISTS `web_ide_info`;
CREATE TABLE `web_ide_info` (
  `service_instance_id` varchar(128) NOT NULL,
  `dashboard_url` varchar(128) NOT NULL,
  `user_id` varchar(128) DEFAULT NULL,
  `use_yn` varchar(1) DEFAULT 'Y',
  `plan_id` varchar(128) NOT NULL,
  `service_id` varchar(128) NOT NULL,
  `space_guid` varchar(128) NOT NULL,
  `organization_guid` varchar(128) NOT NULL,
  PRIMARY KEY (`service_instance_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


-- ----------------------------
-- Table structure for web_ide_service_list
-- ----------------------------
DROP TABLE IF EXISTS `web_ide_service_list`;
CREATE TABLE `web_ide_service_list` (
  `no` int(11) NOT NULL AUTO_INCREMENT,
  `web_ide_service` varchar(128) NOT NULL,
  PRIMARY KEY (`no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
