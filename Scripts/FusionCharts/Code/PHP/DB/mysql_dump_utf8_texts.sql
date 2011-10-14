/*
SQLyog Community Edition- MySQL GUI v5.22a
Host - 5.0.37-community-nt : Database - sales
*********************************************************************
Server version : 5.0.37-community-nt
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

create database if not exists `sales`;

/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

/*Table structure for table `monthly_utf8` */

CREATE TABLE `monthly_utf8` (
  `month_name` varchar(20) character set utf8 default NULL,
  `amount` decimal(10,0) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `monthly_utf8` */

insert  into `monthly_utf8`(`month_name`,`amount`) values ('januÃ¡ri','17400');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('FevruÃ¡rios','19800');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('Ù…Ø§Ø±Ø³','2180');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('Ø£Ø¨Ø±ÙŠÙ„','23800');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('äº”æœˆ','29600');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('å…­æœˆ','27600');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('×ªÖ´Ö¼×©××¨Ö´×™','31800');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('MareÅ¡wÄn','39700');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('settÃ¨mbre','37800');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('ottÃ gono','21900');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('novÃ¨mbre','32900');
insert  into `monthly_utf8`(`month_name`,`amount`) values ('dÃ©cembr','39800');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;