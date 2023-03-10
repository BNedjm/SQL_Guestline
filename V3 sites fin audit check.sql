update Audit set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (audit.PaidAtTS >= OpenPeriod and audit.PaidAtTS <= ClosePeriod) and Terminal = audit.PaidAtTerminal) Where PaidAtTS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = audit.PaidAtTerminal)



update AuditStock set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (AuditStock.ts >= OpenPeriod and AuditStock.ts <= ClosePeriod) and Terminal = AuditStock.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = AuditStock.Terminal)



update CashDeclaration set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (CashDeclaration.Ts >= OpenPeriod and CashDeclaration.ts <= ClosePeriod) and Terminal = CashDeclaration.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = CashDeclaration.Terminal)



update CurrentOrders set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (CurrentOrders.OrderedFromTS >= OpenPeriod and CurrentOrders.OrderedFromTS <= ClosePeriod) and Terminal = CurrentOrders.OrderedFromTerminal) Where CurrentOrders.OrderedFromTS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = CurrentOrders.OrderedFromTerminal)



update FloatDeclaration set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (FloatDeclaration.TS >= OpenPeriod and FloatDeclaration.TS <= ClosePeriod) and Terminal = FloatDeclaration.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = FloatDeclaration.Terminal)



update logPMSLedgerPost set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (logPMSLedgerPost.TS >= OpenPeriod and logPMSLedgerPost.TS <= ClosePeriod) and Terminal = logPMSLedgerPost.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = logPMSLedgerPost.Terminal)



update logPMSRoomPost set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (logPMSRoomPost.TS >= OpenPeriod and logPMSRoomPost.TS <= ClosePeriod) and Terminal = logPMSRoomPost.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = logPMSRoomPost.Terminal)



update TaxReport set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (TaxReport.TS >= OpenPeriod and TaxReport.TS <= ClosePeriod) and Terminal = TaxReport.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = TaxReport.Terminal)



update VoidedItems set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (VoidedItems.OrderedFromTS >= OpenPeriod and VoidedItems.OrderedFromTS <= ClosePeriod) and Terminal = VoidedItems.OrderedFromTerminal) Where VoidedFromTS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = VoidedItems.VoidedFromTerminal)



update Wastage set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (Wastage.WastageFromTS >= OpenPeriod and Wastage.WastageFromTS <= ClosePeriod) and Terminal = Wastage.WastageFromTerminal) Where WastageFromTS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = Wastage.WastageFromTerminal)



update ZreadBlindDeclaration set PeriodID = (Select PeriodID from finPeriods where PeriodType = 2 and (ZreadBlindDeclaration.TS >= OpenPeriod and ZreadBlindDeclaration.TS <= ClosePeriod) and Terminal = ZreadBlindDeclaration.Terminal) Where TS < (Select OpenPeriod from finPeriods where PeriodType = 2 and [Status] = 0 and Terminal = ZreadBlindDeclaration.Terminal)
