
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Load the original Superstore dataset
file_path = "data/raw/Sample - Superstore.csv.xlsx"
df = pd.read_excel(file_path)

# Display basic information
print("Dataset loaded successfully!")
print("\nFirst 5 rows:")
print(df.head())

print("\nDataset shape (rows, columns):")
print(df.shape)

print("\nColumn names:")
print(df.columns.tolist())


# Step 2: Inspect data types and missing values

print("\n--- DATASET INFORMATION ---")
df.info()

print("\n--- MISSING VALUES PER COLUMN ---")
print(df.isnull().sum())

print("\n--- TOTAL MISSING VALUES ---")
print(df.isnull().sum().sum())

print("\n--- DUPLICATE ROWS ---")
print(df.duplicated().sum())

print("\n--- NUMERIC SUMMARY ---")
print(df[["Sales", "Quantity", "Discount", "Profit"]].describe())


# Step 3: Check and correct data types

print("\n--- DATA TYPES BEFORE CONVERSION ---")
print(df.dtypes)

# Convert date columns to datetime format
df["Order Date"] = pd.to_datetime(df["Order Date"], errors="coerce")
df["Ship Date"] = pd.to_datetime(df["Ship Date"], errors="coerce")

# Convert numeric columns to numeric format
numeric_columns = ["Sales", "Quantity", "Discount", "Profit"]

for col in numeric_columns:
    df[col] = pd.to_numeric(df[col], errors="coerce")

print("\n--- DATA TYPES AFTER CONVERSION ---")
print(df.dtypes[["Order Date", "Ship Date", "Sales",
                 "Quantity", "Discount", "Profit"]])

print("\n--- INVALID DATE VALUES ---")
print("Order Date:", df["Order Date"].isna().sum())
print("Ship Date:", df["Ship Date"].isna().sum())

print("\n--- MISSING VALUES AFTER CONVERSION ---")
print(df[["Order Date", "Ship Date"] + numeric_columns].isna().sum())


# STEP 4: BUSINESS KPI ANALYSIS

print("\n--- BUSINESS KPIs ---")

total_sales = df["Sales"].sum()
total_profit = df["Profit"].sum()
total_orders = df["Order ID"].nunique()
total_quantity = df["Quantity"].sum()
overall_profit_margin = (total_profit / total_sales) * 100

print(f"Total Sales: ${total_sales:,.2f}")
print(f"Total Profit: ${total_profit:,.2f}")
print(f"Unique Orders: {total_orders:,}")
print(f"Units Sold: {total_quantity:,}")
print(f"Overall Profit Margin: {overall_profit_margin:.2f}%")

# STEP 5: SALES AND PROFIT BY REGION

print("\n--- SALES AND PROFIT BY REGION ---")

region_analysis = (
    df.groupby("Region")
    .agg(
        Total_Sales=("Sales", "sum"),
        Total_Profit=("Profit", "sum"),
        Total_Orders=("Order ID", "nunique")
    )
    .sort_values("Total_Sales", ascending=False)
)

print(region_analysis.round(2))


# STEP 6: PYTHON DATA VISUALIZATION

# 1. Monthly Sales Trend
monthly_sales = (
    df.set_index("Order Date")
    .resample("MS")["Sales"]
    .sum()
)

plt.figure(figsize=(12, 5))
monthly_sales.plot(kind="line", marker="o")
plt.title("Monthly Sales Trend (2014–2017)")
plt.xlabel("Month")
plt.ylabel("Total Sales")
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.savefig("screenshots/monthly_sales_trend.png", dpi=300)
plt.show()


# 2. Sales by Category
category_sales = (
    df.groupby("Category")["Sales"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(8, 5))
category_sales.plot(kind="bar")
plt.title("Total Sales by Category")
plt.xlabel("Product Category")
plt.ylabel("Total Sales")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("screenshots/sales_by_category.png", dpi=300)
plt.show()


# 3. Profit by Region
region_profit = (
    df.groupby("Region")["Profit"]
    .sum()
    .sort_values(ascending=False)
)

plt.figure(figsize=(8, 5))
region_profit.plot(kind="bar")
plt.title("Total Profit by Region")
plt.xlabel("Region")
plt.ylabel("Total Profit")
plt.xticks(rotation=0)
plt.tight_layout()
plt.savefig("screenshots/profit_by_region.png", dpi=300)
plt.show()

print("\nCharts created and saved in the screenshots folder!")
