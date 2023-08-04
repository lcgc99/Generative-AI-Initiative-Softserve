USE	[WideWorldImportersDW-Standard]

GO

WITH [current] AS (
    SELECT	[Stock Item Key], 
			[year]				= DATEPART(YEAR, [Invoice Date Key]),
			[quarter]			= DATEPART(QUARTER, [Invoice Date Key]),
			total_revenue		= SUM(Quantity * [Unit Price]),
			total_quantity		= SUM(Quantity)
    FROM	[Fact].[Sale]
    GROUP BY [Stock Item Key], DATEPART(YEAR, [Invoice Date Key]), DATEPART(QUARTER, [Invoice Date Key])
),
previous AS (
    SELECT [Stock Item Key],
           [quarter],
		   [year],
           total_revenue,
		   total_quantity,
		   prev_total_revenue	= LAG(total_revenue) OVER(PARTITION BY [Stock Item Key]	ORDER BY [year], [quarter]),
		   prev_total_quantity	= LAG(total_quantity) OVER(PARTITION BY [Stock Item Key]	ORDER BY [year], [quarter])
    FROM [current]
)
SELECT	[ProductName]			= i.[Stock Item],
		[GrowthRevenueRate]		= (p.total_revenue - p.prev_total_revenue)*100/p.prev_total_revenue,
		[CurrentQuarter]		= total_revenue, 
		[PreviousQuarter]		= prev_total_revenue,
		[GrowthQuantityRate]	= (p.total_quantity - p.prev_total_quantity)*100/p.prev_total_quantity,
		[CurrentYear]			= total_quantity,
		[PreviousYear]			= prev_total_quantity
FROM	previous																p
JOIN	Dimension.[Stock Item]													i
	ON	p.[Stock Item Key]	= i.[Stock Item Key]