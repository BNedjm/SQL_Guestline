

DECLARE @PeriodID int

--PUT THE PERIOD ID NUMBER YOU ARE CHECKING HERE--

SET @PeriodID = 10000

SELECT c.[PeriodID],c.[OrderNumber],SUM(c.TrxAmount) as TrxAmount,SUM(c.LgRmPostAmount)AS LgRmPostAmount,SUM(c.AuditAmt)AS AuditAmt

FROM ((SELECT a.[PeriodID],a.[OrderNo] AS OrderNumber,SUM(a.[Amount]) AS TrxAmount, SUM(a.[Amount]) AS LgRmPostAmount, '' AS AuditAmt

FROM [dbo].[logPMSRoomPost] as a

WHERE a.PeriodID = @PeriodID

GROUP BY a.[PeriodID],a.[OrderNo])

UNION ALL

(SELECT b.[PeriodID],b.[OrderNumber],SUM(b.ActualPrice) as TrxAmount, '' AS LgRmPostAmount, SUM(b.ActualPrice) AS AuditAmt

FROM [dbo].[Audit] as b

WHERE b.[PaymentCode] IN ('VOUCHER','ROOM XFR','Spa Vouchers') AND b.PeriodID = @PeriodID

GROUP BY b.[PeriodID],b.[OrderNumber])) as c

GROUP BY c.[PeriodID],c.[OrderNumber]

HAVING SUM(c.TrxAmount) <> 0

ORDER BY c.[PeriodID],c.[OrderNumber]
