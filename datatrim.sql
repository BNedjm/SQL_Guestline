USE P03_SITENAME





DECLARE @Date AS datetime
SET @Date = '2015-08-16'





DELETE FROM Audit WHERE PaidAtTS < @Date
