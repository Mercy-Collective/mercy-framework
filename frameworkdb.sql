/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Databasestructuur van mercy-framework wordt geschreven
CREATE DATABASE IF NOT EXISTS `mercy-framework` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `mercy-framework`;

-- Structuur van  tabel mercy-framework.bans wordt geschreven
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
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.hotel_rooms wordt geschreven
CREATE TABLE IF NOT EXISTS `hotel_rooms` (
  `RoomId` int(11) DEFAULT NULL,
  `RoomInfo` text DEFAULT NULL,
  `Available` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `hotel_rooms` (`RoomId`, `RoomInfo`, `Available`) VALUES
	(501, 'Room-501', 1),
	(502, 'Room-502', 1),
	(503, 'Room-503', 1),
	(504, 'Room-504', 1),
	(505, 'Room-505', 1),
	(506, 'Room-506', 1),
	(507, 'Room-507', 1),
	(508, 'Room-508', 1),
	(509, 'Room-509', 1),
	(510, 'Room-510', 1),
	(511, 'Room-511', 1),
	(512, 'Room-512', 1),
	(513, 'Room-513', 1),
	(514, 'Room-514', 1),
	(515, 'Room-515', 1),
	(516, 'Room-516', 1),
	(517, 'Room-517', 1),
	(518, 'Room-518', 1),
	(519, 'Room-519', 1),
	(520, 'Room-520', 1),
	(521, 'Room-521', 1),
	(522, 'Room-522', 1),
	(523, 'Room-523', 1),
	(524, 'Room-524', 1);

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.logs wordt geschreven
CREATE TABLE IF NOT EXISTS `logs` (
  `Type` text DEFAULT NULL,
  `Steam` varchar(255) DEFAULT NULL,
  `Date` timestamp NULL DEFAULT current_timestamp(),
  `Log` text DEFAULT NULL,
  `Cid` varchar(50) DEFAULT NULL,
  `Data` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_announcements wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `text` mediumtext DEFAULT NULL,
  `created` bigint(255) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_evidences wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_evidences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(50) DEFAULT NULL,
  `identifier` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `scums` longtext DEFAULT NULL,
  `evidence` longtext DEFAULT NULL,
  `reportid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=514592 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_legislation wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_legislation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created` bigint(255) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_profiles wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `priors` text DEFAULT NULL,
  `charges` text DEFAULT NULL,
  `wanted` varchar(50) DEFAULT 'False',
  `created` bigint(255) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_reports wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_reports` (
  `report` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `content` longtext DEFAULT NULL,
  `author` varchar(50) DEFAULT NULL,
  `tags` text DEFAULT '[]',
  `officers` text DEFAULT '[]',
  `scums` text DEFAULT '[]',
  `evidences` varchar(50) DEFAULT '[]',
  `created` bigint(255) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000),
  PRIMARY KEY (`report`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_staff wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_staff` (
  `id` int(11) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `rank` varchar(50) DEFAULT NULL,
  `image` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `callsign` varchar(50) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `tags` text DEFAULT NULL,
  `created` bigint(20) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.mdw_warrants wordt geschreven
CREATE TABLE IF NOT EXISTS `mdw_warrants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `report` varchar(50) DEFAULT NULL,
  `mugshot` text NOT NULL,
  `expires` bigint(20) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.players wordt geschreven
CREATE TABLE IF NOT EXISTS `players` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Cid` int(11) DEFAULT NULL,
  `CitizenId` varchar(50) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `Identifiers` text DEFAULT NULL,
  `Money` text DEFAULT NULL,
  `CharInfo` text DEFAULT NULL,
  `Job` tinytext DEFAULT NULL,
  `Position` text DEFAULT NULL,
  `Inventory` varchar(64000) DEFAULT '{}',
  `Globals` text DEFAULT NULL,
  `Skin` text DEFAULT NULL,
  `Licenses` text DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`CitizenId`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=4161 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_accounts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `CitizenId` varchar(50) DEFAULT NULL,
  `Type` varchar(50) DEFAULT NULL,
  `Name` varchar(50) DEFAULT NULL,
  `BankId` varchar(50) DEFAULT NULL,
  `Balance` bigint(60) DEFAULT 0,
  `Authorized` varchar(500) DEFAULT NULL,
  `Transactions` varchar(60000) DEFAULT '[]',
  `Active` int(11) DEFAULT 1,
  `Monitoring` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=378 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_business wordt geschreven
CREATE TABLE IF NOT EXISTS `player_business` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `employees` longtext DEFAULT '[]',
  `ranks` text DEFAULT '{"Employee":{"Name":"Employee","Default":true,"Permissions":{"pay_employee":false,"stash_access":false,"charge_external":false,"craft_access":false,"property_keys":false,"pay_external":false,"hire":false,"change_role":false,"fire":false}}, "Owner":{"Name":"Owner","Default":true,"Permissions":{"pay_employee":true,"stash_access":true,"charge_external":true,"craft_access":true,"property_keys":true,"pay_external":false,"hire":true,"change_role":true,"fire":true}}}',
  `logo` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=23 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_houses wordt geschreven
CREATE TABLE IF NOT EXISTS `player_houses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT '[]',
  `house` varchar(50) DEFAULT NULL,
  `label` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `owned` varchar(50) DEFAULT 'true',
  `coords` text DEFAULT NULL,
  `locations` text DEFAULT '[]',
  `hasgarage` int(11) DEFAULT NULL,
  `garage` varchar(200) DEFAULT '[]',
  `keyholders` text DEFAULT '[]',
  `decorations` longtext DEFAULT NULL,
  `active` int(11) DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=996 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_house_plants wordt geschreven
CREATE TABLE IF NOT EXISTS `player_house_plants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `houseid` varchar(50) DEFAULT '11111',
  `plants` varchar(65000) DEFAULT '[]',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=60 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_inventory-stash wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-stash` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stash` varchar(50) NOT NULL,
  `items` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5112 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_inventory-vehicle wordt geschreven
CREATE TABLE IF NOT EXISTS `player_inventory-vehicle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `plate` varchar(50) NOT NULL,
  `trunkitems` longtext DEFAULT NULL,
  `gloveboxitems` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=5401 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_outfits wordt geschreven
CREATE TABLE IF NOT EXISTS `player_outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4728 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_phone_contacts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=147 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Structuur van  tabel mercy-framework.player_phone_tweets wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `CitizenId` varchar(50) DEFAULT NULL,
  `Tweeter` varchar(50) DEFAULT NULL,
  `Message` text DEFAULT NULL,
  `Time` datetime DEFAULT NULL,
  `IsBusiness` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_phone_debts wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_debts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `expire` bigint(100) DEFAULT NULL,
  `data` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_phone_documents wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_documents` (
  `citizenid` varchar(50) DEFAULT NULL,
  `id` int(11) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `content` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_phone_messages wordt geschreven
CREATE TABLE IF NOT EXISTS `player_phone_messages` (
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_skins wordt geschreven
CREATE TABLE IF NOT EXISTS `player_skins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) NOT NULL DEFAULT '',
  `model` varchar(50) NOT NULL DEFAULT '0',
  `skin` text NOT NULL,
  `tatoos` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=21657 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_vehicles wordt geschreven
CREATE TABLE IF NOT EXISTS `player_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT 'apartment_1',
  `state` varchar(50) DEFAULT 'In',
  `mods` text DEFAULT NULL,
  `damage` text DEFAULT '{"Doors":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false},"Windows":{"1":true,"2":true,"3":true,"4":false,"5":false,"6":true,"7":true,"0":true},"Tyres":{"1":false,"2":false,"3":false,"4":false,"5":false,"0":false}}',
  `metadata` varchar(1000) DEFAULT '{"Engine":1000.0,"Body":1000.0,"Fuel":100.0,"Nitrous":0,"Harness":0}',
  `parts` varchar(1000) DEFAULT '{"Engine":100.0,"Body":100.0,"Fuel":100.0,"Transmission":100,"FuelInjectors":100,"Axle":100,"Clutch":100,"Brakes":100}',
  `vin` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'Player',
  `impounddata` longtext DEFAULT NULL,
  `Flagged` int(11) DEFAULT 0,
  `FlagReason` text DEFAULT 'No reason',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4906 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.player_weedplants wordt geschreven
CREATE TABLE IF NOT EXISTS `player_weedplants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `PlantId` int(11) DEFAULT NULL,
  `PlantData` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.server_bans wordt geschreven
CREATE TABLE IF NOT EXISTS `server_bans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `reason` varchar(250) DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(50) DEFAULT 'Server PC',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=346 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.server_cardealer wordt geschreven
CREATE TABLE IF NOT EXISTS `server_cardealer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vehicle` varchar(50) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.server_lapraces wordt geschreven
CREATE TABLE IF NOT EXISTS `server_lapraces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `raceid` (`raceid`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporteren was gedeselecteerd

-- Structuur van  tabel mercy-framework.server_users wordt geschreven
CREATE TABLE IF NOT EXISTS `server_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `ip` varchar(75) DEFAULT NULL,
  `permission` varchar(50) DEFAULT 'user',
  `token` varchar(50) DEFAULT NULL,
  `priority` int(11) DEFAULT 3,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=140 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Structuur van  tabel mercy-framework.server_logs wordt geschreven
CREATE TABLE IF NOT EXISTS `server_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(50) DEFAULT NULL,
  `name` text DEFAULT NULL,
  `log` text DEFAULT NULL,
  `date` bigint(255) DEFAULT floor(unix_timestamp(current_timestamp(3)) * 1000),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporteren was gedeselecteerd

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
