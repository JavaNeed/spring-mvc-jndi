create database test;

use test;

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;


INSERT INTO users(username,password,email) VALUES ('chrisr', 'passw0rd@00', 'chris.roggers@gmail.com');
INSERT INTO users(username,password,email) VALUES ('johnk', 'passw0rd@00', 'john.kerr@gmail.com');
INSERT INTO users(username,password,email) VALUES ('sallyk', 'passw0rd@00', 'sally.cox@gmail.com');
INSERT INTO users(username,password,email) VALUES ('mikeh', 'passw0rd@00', 'mike.harford@gmail.com');
INSERT INTO users(username,password,email) VALUES ('savanis', 'passw0rd@00', 'savani.shende@gmail.com');
INSERT INTO users(username,password,email) VALUES ('deepakj', 'passw0rd@00', 'deepak.jaiswal@gmail.com');