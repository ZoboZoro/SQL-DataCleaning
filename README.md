# 🏙️ Nashville Housing Data Cleaning (SQL)

This project contains a SQL script for cleaning and standardizing the **Nashville housing dataset** stored in a Microsoft SQL Server database. The goal is to prepare the data for analysis by handling missing values, fixing inconsistent formats, and removing duplicates.

---

## 📋 Overview

The script performs a series of **data cleaning and transformation operations** on the `Demograph.dbo.Nashville` table, including:

1. **Standardizing Date Format**

   * Converts `SaleDate` from `DATETIME` to a clean `DATE` column (`SaleDateStd`).

2. **Handling Missing Values**

   * Uses a **self-join** and `ISNULL()` to fill missing `PropertyAddress` entries based on matching `ParcelID` values.

3. **Splitting Address Fields**

   * Splits `PropertyAddress` into `PropertyStreet` and `PropertyCity`.
   * Splits `OwnerAddress` into `OwnerStreet`, `OwnerCity`, and `OwnerState` using `PARSENAME()`.

4. **Standardizing Boolean Columns**

   * Replaces `'Y'`/`'N'` values in `SoldAsVacant` with `'Yes'`/`'No'` using an `UPDATE` with `CASE`.

5. **Removing Duplicates**

   * Identifies duplicates using a **CTE with `ROW_NUMBER()`** and deletes extra records.

6. **Dropping Redundant Columns**

   * Removes obsolete columns (`PropertyAddress`, `OwnerAddress`, `SaleDate`, `TaxDistrict`) after transformations.

---

## 🧰 Tech Stack

* **SQL Server (T-SQL)**
* **CTEs**, **String Functions**, **CASE statements**, and **ALTER/UPDATE operations**

---

## 📈 Outcome

After running this script:

* Dates are standardized
* Missing addresses are filled
* Addresses are structured into components
* Boolean fields are normalized
* Duplicate rows are removed
* Redundant columns are dropped

---

## 🧑‍💻 Author

**Taofeecoh Adesanu**
---

