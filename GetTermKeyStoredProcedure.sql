USE kdubois1_IronwoodDW
GO

CREATE PROCEDURE Staging.procedure_getTermKey 
	@term	VARCHAR(10),
	@day	VARCHAR(8),
	@time	DATETIME,
	@dateKey AS BIGINT OUTPUT

AS
BEGIN
	SELECT	@dateKey = datekey
	FROM	Dimension.TermDates
	WHERE	termLabel = @term
	AND		dayLabel = @day
	AND		classtime = @time
END
GO