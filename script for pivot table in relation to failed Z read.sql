--running this script will return the data required for pivot table; the old columns ACMNZ; make sure you enter the periodid number in correct position--

SELECT ChargeCode, PaymentCode, OrderNumber, ActualPrice
FROM     Audit
WHERE  (PeriodID = 12319)
ORDER BY 4
