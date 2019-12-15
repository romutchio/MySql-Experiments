CREATE PROCEDURE GetTotalDriversTimeForStage(IN stageId INT)
BEGIN
    DECLARE finished INT;
    DECLARE driverId INT;
    DECLARE checkpoint INT;
    DECLARE time DATETIME;

    DECLARE SomeCursorName
        CURSOR FOR
        SELECT Results.DriverID, Results.Time, Results.CheckpoitID
        FROM Results
        WHERE Results.StageID = stageId;

    DECLARE CONTINUE
        HANDLER FOR
        NOT FOUND SET finished = 1;

    CREATE TABLE IF NOT EXISTS tempRecords
    (
        driverId INT,
        time     DATETIME
    );

    CREATE TABLE IF NOT EXISTS TotalRaceTimeForDriver
    (
        StageId       INT,
        StageName     VARCHAR(100),
        DriverId      INT,
        DriverName    VARCHAR(100),
        TimeInSeconds INT
    );


    OPEN SomeCursorName;
    getRecord:
    LOOP
        FETCH SomeCursorName INTO driverId, time, checkpoint;
        IF finished = 1 THEN
            LEAVE getRecord;
        END IF;

        IF NOT EXISTS(SELECT 1 FROM tempRecords WHERE tempRecords.driverId = driverId) THEN
            INSERT INTO tempRecords VALUE (driverId, time);
        ELSE
            IF ((SELECT Stage.Checkpoints FROM Stage WHERE Stage.StageID = stageId) = checkpoint) THEN
                SET @stageName = (SELECT Stage.StageName FROM Stage WHERE Stage.StageID = stageId);
                SET @driverName = (SELECT Driver.DriverName FROM Driver WHERE Driver.DriverId = driverId);
                SET @startTime = (SELECT tempRecords.time FROM tempRecords WHERE tempRecords.driverId = driverId);
                SET @totalTime = TIMESTAMPDIFF(SECOND, @startTime, time);
                INSERT INTO TotalRaceTimeForDriver VALUE (stageId, @stageName, driverId, @driverName, @totalTime);
            end if;
        end if;
    END LOOP getRecord;
    DROP TABLE tempRecords;
    CLOSE SomeCursorName;
END;

-- CALL IT AND TEST IT
CALL GetTotalDriversTimeForStage(1);

-- DELETE IF NEEDED
DROP PROCEDURE GetTotalDriversTimeForStage;
DROP TABLE TotalRaceTimeForDriver;
