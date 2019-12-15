CREATE TABLE Rating
SELECT ROW_NUMBER() OVER () AS Place,
       Results.DriverID,
       Driver.DriverName,
       Results.StageID,
       Stage.StageName,
       Results.TIME
FROM Results,
     Driver,
     Stage
WHERE Driver.DriverID = Results.DriverID
  AND Results.StageID = Stage.StageID
  AND Results.CheckpoitID = Stage.Checkpoints
ORDER BY Time;

-- DELETE IF NEEDED
DROP TABLE Rating;