CREATE TRIGGER OnDriverAdd_WhenPreviousCheckpointExists
    BEFORE INSERT
    ON Results
    FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Results
                  WHERE Results.StageID = NEW.StageID
                    AND Results.DriverID = NEW.DriverID
                    AND Results.CheckpoitID = NEW.CheckpoitID - 1)
        AND NEW.CheckpoitID > 1 THEN
        BEGIN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = "This driver was not registered on previous checkpoint!";
        END;
    END IF;
END;

-- ADD NEW RECORD TO TABLE
INSERT INTO `Results` (`ResultID`, `StageID`, `CheckpoitID`, `DriverID`, `Time`) VALUES ('107', '2', '3', '1', '2019-12-01 10:00:03');

-- DELETE TRIGGER
DROP TRIGGER OnDriverAdd_WhenPreviousCheckpointExists;
