USE	[WideWorldImportersDW-Standard]

GO

WITH Top_Selling_Products AS (
	SELECT	TOP 10
			[Stock Item Key]
	FROM	Fact.Sale												s									
	GROUP BY	[Stock Item Key]
	ORDER BY	SUM([Quantity] * [Unit Price]) DESC
)
SELECT	
	[ProductName]	= i.[Stock Item], 
	[Year]			= DATEPART(YEAR, s.[Invoice Date Key]),
	[Quarter]		= DATEPART(QUARTER, s.[Invoice Date Key]), 
	[SalesQuantity]	= SUM(s.Quantity), 
	[SalesRevenue]	= SUM(s.Quantity * s.[Unit Price])
--SELECT	COUNT(1)
FROM	Fact.Sale													s					--	228,265
JOIN	Top_Selling_Products										t
	ON	s.[Stock Item Key] = t.[Stock Item Key]											--	10,517
JOIN	Dimension.[Stock Item]										i
	ON	s.[Stock Item Key] = i.[Stock Item Key]											--	10,517
GROUP BY	i.[Stock Item], DATEPART(YEAR, s.[Invoice Date Key]), DATEPART(QUARTER, s.[Invoice Date Key])