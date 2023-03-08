
--After running 1. New Z Read imbalance script - Create Stored Procedure, take the periodId of the failed Z read and insert in; Set @PeriodID = [Periodid]. This will display true sales or payment that are missing--

Declare @PeriodID int
DECLARE @ZreadStart as datetime
DECLARE @ZreadEnd as datetime
DECLARE @ZreadTerminal as nvarchar(50)

Set @PeriodID = 11270

SET @ZreadStart = (Select OpenPeriod from  finPeriods where PeriodID = @PeriodID)

SET @ZreadEnd = (Select ClosePeriod from  finPeriods where PeriodID = @PeriodID)

SET @ZreadTerminal = (Select Terminal from  finPeriods where PeriodID = @PeriodID)

SELECT SUM(Amount) AS SumPMSSales
FROM dbo.logPMSZReadSales
WHERE (PeriodID >= @PeriodID AND PeriodID <= @PeriodID)

SELECT SUM(Amount) AS SumPMSPayments
FROM [dbo].[logPMSZReadPayments]
WHERE (PeriodID >= @PeriodID AND PeriodID <= @PeriodID)

-----------------Sales
SELECT ChargeCode, SUM([ActualPrice]) as SoldInPos
FROM [dbo].[Audit] 
WHERE (PaidAtTS >= @ZreadStart and PaidAtTS <= @ZreadEnd) and PaidAtTerminal  = @ZreadTerminal
                                AND OrderNumber Not In (SELECT OrderNumber FROM [dbo].[Audit] WHERE PaymentCode IN ('ACCOUNT XFR', 'ROOM XFR') And ChargeCode = '') 
                                AND PaymentCode = ''
                                GROUP BY ChargeCode
                                ORDER BY ChargeCode

SELECT POSCode, SUM(Amount) AS SentToPMSSales
FROM dbo.logPMSZReadSales
WHERE (PeriodID = @PeriodID)
GROUP BY POSCode
ORDER BY POSCode


----------------Payments

SELECT PaymentCode, SUM(ActualPrice) AS TakenInPOS
FROM dbo.Audit
WHERE (PaidAtTS >= @ZreadStart and PaidAtTS <= @ZreadEnd)  and PaidAtTerminal  = @ZreadTerminal AND PaymentCode NOT IN ('ACCOUNT XFR', 'ROOM XFR') And ChargeCode = ''
GROUP BY PaymentCode
ORDER BY PaymentCode

SELECT POSPayType, SUM(Amount) AS SentToPMSPayments
FROM dbo.logPMSZReadPayments
WHERE (PeriodID = @PeriodID)
GROUP BY POSPayType
ORDER BY POSPayType
