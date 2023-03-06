--Cleaning Data in SQL
Select * from PortfolioProjectTwo.dbo.NashvilleHousing


------

--Change Sale Date

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProjectTwo.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


----

--Populate Property Addres
Select *
From PortfolioProjectTwo.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectTwo.dbo.NashvilleHousing a
JOIN PortfolioProjectTwo.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjectTwo.dbo.NashvilleHousing a
JOIN PortfolioProjectTwo.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]

----

--Breaking out the Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProjectTwo.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID


SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProjectTwo.dbo.NashvilleHousing

ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 


Select *
From PortfolioProjectTwo.dbo.NashvilleHousing




Select OwnerAddress
From PortfolioProjectTwo.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjectTwo.dbo.NashvilleHousing


ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)



ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE PortfolioProjectTwo.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProjectTwo.dbo.NashvilleHousing




----
-- Change Y and N to Yes and No in "Sold as Vacant" field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjectTwo.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjectTwo.dbo.NashvilleHousing

Update PortfolioProjectTwo.dbo.NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


----
--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProjectTwo.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProjectTwo.dbo.NashvilleHousing



----
--Delete Unused Columns

Select *
From PortfolioProjectTwo.dbo.NashvilleHousing

Alter Table PortfolioProjectTwo.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate