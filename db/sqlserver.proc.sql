CREATE OR ALTER FUNCTION date_add (@dat datetime, @days int)
RETURNS datetime
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN dateadd(day, @days, @dat);
END;
GO
CREATE OR ALTER FUNCTION date_sub (@dat datetime, @days int)
RETURNS datetime
WITH EXECUTE AS CALLER
AS
BEGIN
	RETURN dateadd(day, 0-@days, @dat);
END;
GO