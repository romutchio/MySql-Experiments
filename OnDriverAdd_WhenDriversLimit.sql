CREATE TRIGGER OnDriverAdd_WhenDriversLimit
    BEFORE INSERT
    ON Results
    FOR EACH ROW
BEGIN
    IF ((SELECT COUNT(DISTINCT DriverID) FROM Results WHERE StageID = NEW.StageID) = 5 AND
        NOT EXISTS(SELECT 1 FROM Results WHERE Results.DriverID = NEW.DriverID AND Results.StageID = NEW.StageID)) THEN
        BEGIN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = "Max amount of drivers for one race - '5'";
        END;
    END IF;
END;

-- ADD NEW RECORD TO TABLE
INSERT INTO `Results` (`ResultID`, `StageID`, `CheckpoitID`, `DriverID`, `Time`) VALUES ('106', '1', '1', '7', '2019-12-01 10:00:03');

-- DELETE TRIGGER
DROP TRIGGER OnDriverAdd_WhenDriversLimit;
