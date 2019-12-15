CREATE PROCEDURE DriverStat(IN driverId INT, IN stageId INT)
BEGIN
    SELECT Results.StageID, Results.CheckpoitID, Results.Time
    FROM Results
    WHERE Results.DriverID = driverId AND Results.StageID = stageID;
END;

-- CALL IT AND TEST IT
CALL DriverStat(1,1);

-- DELETE IF NEEDED
DROP PROCEDURE DriverStat;