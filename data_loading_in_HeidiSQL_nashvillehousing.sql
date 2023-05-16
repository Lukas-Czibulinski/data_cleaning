/*

data loading in HeidiSQL

*/

CREATE TABLE `portfolioproject`.`nashvillehousing` (
	`_uniqueid` MEDIUMINT NULL,
	`parcelid` VARCHAR(20) NOT NULL,
	`landuse` VARCHAR(50) NOT NULL,
	`propertyaddress` VARCHAR(50) NULL,
	`saledate` VARCHAR(20) NULL,
	`saleprice` VARCHAR(20) NOT NULL,
	`legalreference` VARCHAR(20) NOT NULL,
	`soldasvacant` VARCHAR(10) NOT NULL,
	`ownername` VARCHAR(60) NULL,
	`owneraddress` VARCHAR(50) NULL,
	`acreage` VARCHAR(10) NULL,
	`taxdistrict` VARCHAR(30) NULL,
	`landvalue` VARCHAR(10) NULL,
	`buildingvalue` VARCHAR(10) NULL,
	`totalvalue` VARCHAR(10) NULL,
	`yearbuilt` VARCHAR(10) NULL,
	`bedrooms` VARCHAR(10) NULL,
	`fullbath` VARCHAR(10) NULL,
	`halfbath` VARCHAR(10) NULL
)
