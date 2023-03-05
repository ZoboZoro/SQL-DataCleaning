
SELECT *
FROM Demograph.dbo.Nashville;


--convert datetime format to date
/*
Converts the first column to the wanted format in another column
SELECT SaleDate, CONVERT(date,SaleDate) StandardDate
FROM Demograph.dbo.Nashville;
*/

-- Adds another column and assigns the data type it's going to take
ALTER TABLE Nashville
ADD SaleDateStd DATE;

--Since the data type in the new column has been specified, moving the DATETIME column to it does the assignment automatically
UPDATE Nashville
SET SaleDateStd = SaleDate;

SELECT SaleDatestd, SaleDate
FROM Demograph.dbo.Nashville;

/* Filling in Null rows */
-- to scan for similar patterns
Select *
FROM Nashville
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

--self join on ParcelID
SELECT One.ParcelID, One.PropertyAddress, Two.ParcelID,Two.PropertyAddress
FROM Nashville One
JOIN Nashville Two
	ON One.ParcelID = Two.ParcelID
WHERE One.PropertyAddress IS NULL 
AND One.[UniqueID ] != Two.[UniqueID ]

-- Using 'ISNULL'
SELECT One.ParcelID, One.PropertyAddress, Two.ParcelID,Two.PropertyAddress, 
ISNULL(One.PropertyAddress, Two.PropertyAddress) IfNullCol
FROM Nashville One
JOIN Nashville Two
	ON One.ParcelID = Two.ParcelID
	AND One.[UniqueID ] != Two.[UniqueID ]
WHERE One.PropertyAddress IS NULL;

-- 
UPDATE One
SET One.PropertyAddress = ISNULL(One.PropertyAddress, Two.PropertyAddress)
FROM Nashville One
JOIN Nashville Two
	ON One.ParcelID = Two.ParcelID
	AND One.[UniqueID ] != Two.[UniqueID ]
WHERE One.PropertyAddress IS NULL;



/* Splitting Address*/
SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) SubStreet,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) SubCity
FROM Nashville;

--Add new columns of property address
ALTER TABLE Nashville 
ADD PropertyStreet NVARCHAR(100), PropertyCity NVARCHAR(50);

UPDATE Nashville
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
FROM Nashville;

UPDATE Nashville
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))
FROM Nashville;


-- CTE to extract street number
WITH CTE AS
(
SELECT PropertyAddress,
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) StreetAddress
FROM Nashville
)
SELECT StreetAddress, SUBSTRING(StreetAddress, 1, CHARINDEX(' ', StreetAddress)) FROM CTE;

-- Same result without CTE
SELECT SUBSTRING(PropertyAddress, 1, 4) 
FROM Nashville

--DROP TABLE IF EXISTS #Temp1 
--CREATE TABLE #Temp1
--(Col1 NVARCHAR(255) NULL
----Col2 NVARCHAR(255),
--);
--INSERT INTO #Temp1
--SELECT PropertyAddress
----SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) StreetAddress
--FROM Nashville


SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM Nashville;

ALTER TABLE Nashville 
ADD OwnerStreet NVARCHAR(100), OwnerCity NVARCHAR(50), OwnerState NVARCHAR(10);

UPDATE Nashville
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
FROM Nashville;

UPDATE Nashville
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
FROM Nashville;

UPDATE Nashville
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM Nashville;


/* Change Y to Yes and N to No */
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant);

SELECT SoldAsVacant FROM Nashville

--Using separate 'UPDATE Statement'
UPDATE Nashville
SET SoldAsVacant = 'Yes' WHERE SoldAsVacant = 'Y';
UPDATE Nashville
SET SoldAsVacant = 'No' WHERE SoldAsVacant = 'N';

-- Using UPDATE with CASE statement
UPDATE Nashville
SET SoldAsVacant 
= CASE
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END


/* Remove duplicates */
WITH CTERowPart AS
(
SELECT *, ROW_NUMBER() 
OVER (PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY UniqueID) RowPart
FROM Nashville
)
DELETE 
FROM CTERowPart
WHERE RowPart > 1


/* Remove obsolete columns */
SELECT * 
FROM Nashville

ALTER TABLE Nashville
DROP COLUMN PropertyAddress, OwnerAddress, SaleDate, TaxDistrict