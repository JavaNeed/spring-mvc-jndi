create database TestDB;

CREATE TABLE `Employee` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(20) DEFAULT NULL,
  `role` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `Employee` (`id`, `name`, `role`) VALUES (1, 'Pankaj', 'CEO'),(2, 'David', 'Manager');
commit;