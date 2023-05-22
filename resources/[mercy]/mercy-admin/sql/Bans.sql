CREATE TABLE IF NOT EXISTS `bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `banid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(255) DEFAULT NULL,
  `license` varchar(255) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedon` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3;