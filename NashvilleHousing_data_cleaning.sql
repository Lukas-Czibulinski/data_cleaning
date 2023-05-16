/*

Cleaning Data with SQL Queries
Used Version MySQL: Version 8.0.31

*/

SELECT*
FROM portfolioproject.nashvillehousing;

-- Disable Safe Mode if it is set 
SET SQL_SAFE_UPDATES = 0;

-- Standardize Date Format 

-- drop the column if the error that it already exists occurs
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN ConvertedSaleDate;

ALTER TABLE portfolioproject.nashvillehousing
ADD ConvertedSaleDate DATE;
UPDATE portfolioproject.nashvillehousing
SET ConvertedSaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %e, %Y'), '%Y-%m-%d');

-- Adding Null values if not set by default 
update portfolioproject.nashvillehousing
set PropertyAddress= null 
where PropertyAddress= '';

-- populate property adress data
SELECT*
FROM portfolioproject.nashvillehousing
-- WHERE PropertyAddress is Null -- looking at missing values
order by ParcelID;

-- filling the null values of property address
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, COALESCE(a.PropertyAddress, b.PropertyAddress)
FROM portfolioproject.nashvillehousing a
JOIN portfolioproject.nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a._uniqueid <> b._uniqueid -- careful when referring to _uniqueid since the coloumn name has an underline
WHERE a.PropertyAddress is null;

UPDATE portfolioproject.nashvillehousing a
JOIN portfolioproject.nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a._uniqueid <> b._uniqueid
SET a.PropertyAddress = COALESCE(a.PropertyAddress, b.PropertyAddress)
WHERE a.PropertyAddress is null;

-- Breaking out the Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM portfolioproject.nashvillehousing;
-- WHERE PropertyAddress is Null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress,',') -1 ) as Address,
SUBSTRING(PropertyAddress, INSTR(PropertyAddress,',') +1, length(PropertyAddress)) as Address
FROM portfolioproject.nashvillehousing;

-- drop the column if the error that it already exists occurs
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN PropertySplitAddress;
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN PropertySplitCity;

ALTER TABLE portfolioproject.nashvillehousing
ADD PropertySplitAddress varchar(60);
UPDATE portfolioproject.nashvillehousing 
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress,',') -1 );

ALTER TABLE portfolioproject.nashvillehousing
ADD PropertySplitCity varchar(60);
UPDATE portfolioproject.nashvillehousing 
SET PropertySplitCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress,',') +1, length(PropertyAddress));


-- breaking the owner address into different columns (another approach)

-- drop the column if the error that it already exists occurs
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN OwnerSplitAddress;

-- adding the split column
ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitAddress varchar(60);
UPDATE portfolioproject.nashvillehousing 
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 1), ',', -3));

-- drop the column if the error that it already exists occurs
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN OwnerSplitCity;

-- adding the split column
ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitCity varchar(60);
UPDATE portfolioproject.nashvillehousing 
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));

-- drop the column if the error that it already exists occurs
-- ALTER TABLE portfolioproject.nashvillehousing
-- DROP COLUMN OwnerSplitState;

-- adding the split column
ALTER TABLE portfolioproject.nashvillehousing
ADD OwnerSplitState varchar(60);
UPDATE portfolioproject.nashvillehousing 
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1));


-- looking at the newly created columns
select owneraddress, Ownersplitaddress, OwnerSplitCity, OwnersplitState
from portfolioproject.nashvillehousing;

-- -------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT distinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM portfolioproject.nashvillehousing
GROUP BY soldasvacant
order by 2;

SELECT soldasvacant,
	CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
	END
FROM portfolioproject.nashvillehousing;

Update nashvillehousing
SET soldasvacant = CASE 
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
	END;
    
    
-- ---------------------------------------------------------------------------------------------------------

-- Remove duplicates
-- joining the table with itself to negate the duplicates

DELETE t1
FROM portfolioproject.nashvillehousing t1
JOIN (
  SELECT
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference,
    MIN(_UniqueID) AS minID
  FROM portfolioproject.nashvillehousing
  GROUP BY PropertyAddress, SalePrice, SaleDate, LegalReference
  HAVING COUNT(*) > 1
) t2 ON t1.PropertyAddress = t2.PropertyAddress
    AND t1.SalePrice = t2.SalePrice
    AND t1.SaleDate = t2.SaleDate
    AND t1.LegalReference = t2.LegalReference
    AND t1._UniqueID > t2.minID;
-- -----------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT*
FROM portfolioproject.nashvillehousing;

-- Should be done when all the previous queries worked and were executed 
ALTER TABLE portfolioproject.nashvillehousing
DROP column OwnerAddress,
DROP column TaxDistrict,
DROP column PropertyAddress;

ALTER TABLE portfolioproject.nashvillehousing
DROP COLUMN SaleDate;