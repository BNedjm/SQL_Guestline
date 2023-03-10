USE [Database Name]
GO
 
/****** Object:  StoredProcedure [dbo].[glsp_ZreadCheck]    Script Date: 31/05/2018 14:34:26 ******/
SET ANSI_NULLS ON
GO
 
SET QUOTED_IDENTIFIER ON
GO
 

 

CREATE PROCEDURE [dbo].[glsp_ZreadCheck]
    AS
 
SET NOCOUNT ON
 
DECLARE @PeriodID As Int
DECLARE @Balance as money
DECLARE @AuditSalesPeriodID as money
DECLARE @AuditPaymentsPeriodID as money
DECLARE @AuditSalesTS as money
DECLARE @AuditPaymentsTS as money
DECLARE @RoomXfrSalesPeriodID as money
DECLARE @LedgerXfrSalesPeriodID as money
DECLARE @AuditCheck as money
DECLARE @SalesCheck as money
DECLARE @SalesCheckPeriodID as money
DECLARE @ZreadPaymentsToPMS as money
DECLARE @ZreadSalesToPMS as money
DECLARE @ZreadDiff as money
DECLARE @ZreadTerminal as nvarchar(50)
DECLARE @ZreadStart as datetime
DECLARE @ZreadEnd as datetime
DECLARE @RoomXfrSalesTS as money
DECLARE @LedgerXfrSalesTS as money
 
CREATE TABLE #ZreadInfo (PeriodID Int, Balance money, AuditSalesPeriodID money, AuditSalesTS money, AuditPaymentsPeriodID money, AuditPaymentsTS money, RoomXfrSalesPeriodID money, RoomXfrSalesTS money, LedgerXfrSalesPeriodID money, LedgerXfrSalesTS Money, ZreadPaymentsToPMS money, ZreadSalesToPMS money, AuditCheck money, SalesCheck money, SalesCheckPeriodID money, ZreadDiff money)
 
DECLARE Zread_cursor CURSOR
 
FOR
SELECT SUM(Amount) AS Balance, PeriodID
FROM    (SELECT        POSPayType AS Code, SUM(Amount * - 1) AS Amount, PeriodID
            FROM            dbo.logZreadPaymentsToPMS
            GROUP BY PeriodID, POSPayType
            UNION
        SELECT        POSCode AS Code, SUM(Amount) AS Amount, PeriodID
            FROM            dbo.logZreadSalesToPMS
            GROUP BY PeriodID, POSCode) AS ZreadBalance
GROUP BY PeriodID
HAVING        (SUM(Amount) <> 0)
OPEN Zread_cursor 
 

 

FETCH NEXT FROM  Zread_cursor INTO @Balance, @PeriodID
 
WHILE @@FETCH_STATUS = 0
BEGIN
        
        SET @ZreadTerminal = (Select Terminal from  finPeriods where PeriodID = @PeriodID)
 
        SET @ZreadStart = (Select OpenPeriod from  finPeriods where PeriodID = @PeriodID)
 
        SET @ZreadEnd = (Select ClosePeriod from  finPeriods where PeriodID = @PeriodID)
 
        SET @AuditSalesTS = (SELECT COALESCE(SUM([ActualPrice]), 0) FROM Audit WHERE (PaidAtTS >= @ZreadStart and PaidAtTS <= @ZreadEnd) AND PaymentCode = '' and PaidAtTerminal  = @ZreadTerminal)
 
        SET @AuditPaymentsTS = (SELECT COALESCE(SUM([ActualPrice]), 0) FROM Audit WHERE (PaidAtTS >= @ZreadStart and PaidAtTS <= @ZreadEnd) AND PaymentCode <> '' and PaidAtTerminal  = @ZreadTerminal)
 
        SET @AuditSalesPeriodID = (SELECT COALESCE(SUM([ActualPrice]), 0) FROM Audit WHERE PeriodID = @PeriodID AND PaymentCode = '' and PaidAtTerminal  = @ZreadTerminal)
 
        SET @AuditPaymentsPeriodID = (SELECT COALESCE(SUM([ActualPrice]), 0) FROM Audit WHERE PeriodID = @PeriodID AND PaymentCode <> '' and PaidAtTerminal  = @ZreadTerminal)
 
        SET @RoomXfrSalesTS = (SELECT COALESCE(SUM([Amount]), 0) FROM logPMSRoomPost WHERE (TS >= @ZreadStart and TS <= @ZreadEnd) and Terminal  = @ZreadTerminal)
 
        SET @RoomXfrSalesPeriodID = (SELECT COALESCE(SUM([Amount]), 0) FROM logPMSRoomPost WHERE PeriodID = @PeriodID and Terminal  = @ZreadTerminal)
 
        SET @LedgerXfrSalesTS = (SELECT COALESCE(SUM([Amount]), 0) FROM logPMSLedgerPost WHERE (TS >= @ZreadStart and TS <= @ZreadEnd)  and Terminal  = @ZreadTerminal)
 
        SET @LedgerXfrSalesPeriodID = (SELECT COALESCE(SUM([Amount]), 0) FROM logPMSLedgerPost WHERE PeriodID = @PeriodID  and Terminal  = @ZreadTerminal)
        
        SET @ZreadPaymentsToPMS = (SELECT COALESCE(SUM([Amount]), 0) FROM logZreadPaymentsToPMS WHERE PeriodID = @PeriodID)
 
        SET @ZreadSalesToPMS = (SELECT COALESCE(SUM([Amount]), 0) FROM logZreadSalesToPMS WHERE PeriodID = @PeriodID)
 
        SET @AuditCheck = @AuditSalesTS + @AuditPaymentsts
 
        SET @SalesCheck = @AuditSalesTS - (@RoomXfrSalesTS + @LedgerXfrSalesTS + @ZreadSalesToPMS)
 
        SET @SalesCheckPeriodID = @AuditSalesPeriodID - (@RoomXfrSalesPeriodID + @LedgerXfrSalesPeriodID + @ZreadSalesToPMS)
 
        Set @ZreadDiff = @ZreadSalesToPMS - @ZreadPaymentsToPMS
        
            
        INSERT INTO #ZreadInfo (PeriodID, Balance, AuditSalesPeriodID, AuditSalesTS, AuditPaymentsPeriodID, AuditPaymentsTS, RoomXfrSalesPeriodID,  RoomXfrSalesTS, LedgerXfrSalesPeriodID,  LedgerXfrSalesTS, ZreadPaymentsToPMS, ZreadSalesToPMS, AuditCheck, SalesCheck, SalesCheckPeriodID, ZreadDiff) Values(@PeriodID, @Balance, @AuditSalesPeriodID, @AuditSalesTS, @AuditPaymentsPeriodID, @AuditPaymentsTS, @RoomXfrSalesPeriodID, @RoomXfrSalesTS,  @LedgerXfrSalesPeriodID, @LedgerXfrSalesTS, @ZreadPaymentsToPMS, @ZreadSalesToPMS, @AuditCheck, @SalesCheck, @SalesCheckPeriodID, @ZreadDiff)
                
    FETCH NEXT FROM  Zread_cursor INTO @Balance, @PeriodID
END    
 

 

SELECT * FROM #ZreadInfo  Order By PeriodID
 
CLOSE Zread_cursor
DEALLOCATE Zread_cursor
 
Drop Table #ZreadInfo
GO

 


EXEC glsp_ZreadCheck
