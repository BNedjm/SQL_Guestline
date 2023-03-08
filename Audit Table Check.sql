1. Audit table check

This SQL query will highlight any out of balance Orders within a certain period. There is a variable for the Period ID you are checking. This will use the open and close timestamps in the FinPeriods table.

DECLARE @PeriodID int

--PUT THE PERIOD ID NUMBER YOU ARE CHECKING HERE--

SET @PeriodID = 19521

SELECT TOP (100) PERCENT aud.PeriodID, aud.OrderNumber, SUM(aud.ActualPrice) AS OrderNumDif

FROM dbo.Audit AS aud INNER JOIN

(SELECT PeriodID, PeriodDescrip, PeriodType, OpenPeriod, ClosePeriod, Status, OperatorCode, Terminal, Success

FROM dbo.finPeriods AS finPeriods_1

WHERE (PeriodType = 2) AND (Status = 110)) AS FinPeriods ON aud.PaidAtTS >= FinPeriods.OpenPeriod AND aud.PaidAtTS < FinPeriods.ClosePeriod

WHERE (FinPeriods.PeriodID = @PeriodID)

GROUP BY aud.PeriodID, aud.OrderNumber

HAVING (SUM(aud.ActualPrice) <> 0)

ORDER BY aud.PeriodID
