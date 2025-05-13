create database hw13;
go
use hw13;

DECLARE @date DATE = GETDATE(); -- or set a custom date
DECLARE @startOfMonth DATE = DATEFROMPARTS(YEAR(@date), MONTH(@date), 1);
DECLARE @endOfMonth DATE = EOMONTH(@date);

DECLARE @currentDate DATE = @startOfMonth;
DECLARE @weekNum INT;
DECLARE @firstDayOfWeek INT = @@DATEFIRST; -- get system setting (1=Monday, 7=Sunday)

-- Create temp table
CREATE TABLE #days (
    DayNum INT,
    WeekNum INT,
    DayOfWeek VARCHAR(10)
);

WHILE @currentDate <= @endOfMonth
BEGIN
    SET @weekNum = DATEPART(WEEK, @currentDate);
    INSERT INTO #days (DayNum, WeekNum, DayOfWeek)
    VALUES (
        DAY(@currentDate),
        @weekNum,
        DATENAME(WEEKDAY, @currentDate)
    );
    SET @currentDate = DATEADD(DAY, 1, @currentDate);
END;

-- Now, get the last occurrence per weekday in each week
SELECT
  MAX(CASE WHEN DayOfWeek = 'Sunday' THEN DayNum END) AS Sunday,
  MAX(CASE WHEN DayOfWeek = 'Monday' THEN DayNum END) AS Monday,
  MAX(CASE WHEN DayOfWeek = 'Tuesday' THEN DayNum END) AS Tuesday,
  MAX(CASE WHEN DayOfWeek = 'Wednesday' THEN DayNum END) AS Wednesday,
  MAX(CASE WHEN DayOfWeek = 'Thursday' THEN DayNum END) AS Thursday,
  MAX(CASE WHEN DayOfWeek = 'Friday' THEN DayNum END) AS Friday,
  MAX(CASE WHEN DayOfWeek = 'Saturday' THEN DayNum END) AS Saturday
FROM #days
GROUP BY WeekNum;

DROP TABLE #days;
