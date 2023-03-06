SELECT * FROM project2..Housing

--convert date
select SaleDateConverted FROM project2..Housing

--
update Housing
set SaleDate= CONVERT(Date, SaleDate)

--ALTER TABLE Housing Add SaleDateConverted Date;

--update Housing
--set SaleDateConverted= CONVERT(Date, SaleDate)

--SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
--FROM project2..Housing a 
--join project2..Housing b
--on a.ParcelID = b.ParcelID
--AND a.[UniqueID ]<>b.[UniqueID ]
--WHERE a.PropertyAddress is null

--update a
--SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
--FROM project2..Housing a 
--join project2..Housing b
--on a.ParcelID = b.ParcelID
--AND a.[UniqueID ]<>b.[UniqueID ]
--WHERE a.PropertyAddress is null

Select PropertyAddress
From project2..Housing

select 
substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from project2..Housing

ALTER TABLE project2..Housing
add PropAddress nvarchar(255);

update project2..Housing
set PropAddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE project2..Housing
add PropCity nvarchar(255);

update project2..Housing
set PropCity = substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from project2..Housing


ALTER TABLE project2..Housing
add OwnerSplitAddress nvarchar(255);

update project2..Housing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


ALTER TABLE project2..Housing
add OwnerCity nvarchar(255);

update project2..Housing
set OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2) 


ALTER TABLE project2..Housing
add OwnerState nvarchar(255);

update project2..Housing
set OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select * from project2..Housing

select Distinct(SoldAsVacant), count(SoldAsVacant)
from project2..Housing
group by SoldAsVacant
order by 2

select SoldAsVacant,
CASE When SoldAsVacant='Y' THEN 'Yes'
	When SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END
from project2..Housing

update Housing
set SoldAsVacant=
CASE When SoldAsVacant='Y' THEN 'Yes'
	When SoldAsVacant='N' THEN 'No'
	ELSE SoldAsVacant
	END

WITH RowNumCTE AS (
select * ,
		ROW_NUMBER()OVER(
		PARTITION BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
			UniqueID) row_num
from project2..Housing
)
select * from RowNumCTE
where row_num>1
order by PropertyAddress

--delete from RowNumCTE where row_num>1

ALTER TABLE project2.dbo.Housing
drop column OwnerAddress, TaxDistrict,PropertyAddress
