CREATE TABLE IF NOT EXISTS `logs` (
  `Type` text DEFAULT NULL,
  `Steam` varchar(255) DEFAULT NULL,
  `Date` timestamp NULL DEFAULT current_timestamp(),
  `Log` text DEFAULT NULL,
  `Cid` varchar(50) DEFAULT NULL,
  `Data` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;