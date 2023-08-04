USE	[WideWorldImportersDW-Standard]

GO

WITH	Total_Values AS (
	SELECT	[year]				= DATEPART(YEAR, [Invoice Date Key]),
			[quarter]			= DATEPART(QUARTER, [Invoice Date Key]),
			total_revenue		= SUM(Quantity * [Unit Price]),
			total_quantity		= SUM(Quantity)
	FROM	[Fact].[Sale]
	GROUP BY DATEPART(YEAR, [Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])
),
Total_Values_By_Customer AS (
	SELECT	[Customer Key], 
			[year]					= DATEPART(YEAR, [Invoice Date Key]),
			[quarter]				= DATEPART(QUARTER, [Invoice Date Key]),
			total_revenue_customer	= SUM(Quantity * [Unit Price]),
			total_quantity_customer	= SUM(Quantity)
	FROM	[Fact].[Sale]
	GROUP BY [Customer Key], DATEPART(YEAR, [Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])
)
SELECT	[CustomerName]				= c.[Customer], 
		[TotalRevenuePercentage]	= 1.0*tvc.total_revenue_customer/NULLIF(tv.total_revenue, 0)*100,
		[TotalQuantityPercentage]	= 1.0*tvc.total_quantity_customer/NULLIF(tv.total_quantity, 0)*100,
		[Quarter]					= tv.[quarter],
		[Year]						= tv.[year]
--SELECT	COUNT(1)
FROM	Total_Values_By_Customer						tvc				--	5641
JOIN	Total_Values									tv
	ON	tvc.[quarter]	= tv.[quarter]
	AND	tvc.[year]		= tv.[year]										--	5641
JOIN	Dimension.Customer								c
	ON	tvc.[Customer Key]	= c.[Customer Key]							--	5641