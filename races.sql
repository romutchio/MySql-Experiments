-- phpMyAdmin SQL Dump
-- version 5.0.0-rc1
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Дек 15 2019 г., 11:01
-- Версия сервера: 8.0.18
-- Версия PHP: 7.2.24-0ubuntu0.18.04.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `racessql`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`bully434`@`%` PROCEDURE `DriverStat` (IN `driverId` INT, IN `stageId` INT)  BEGIN
    SELECT Results.StageID, Results.CheckpoitID, Results.Time
    FROM Results
    WHERE Results.DriverID = driverId AND Results.StageID = stageID;
END$$

CREATE DEFINER=`bully434`@`%` PROCEDURE `GetTotalDriversTimeForStage` (IN `stageId` INT)  BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `Driver`
--

CREATE TABLE `Driver` (
  `DriverID` int(100) NOT NULL,
  `DriverName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Car` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `Driver`
--

INSERT INTO `Driver` (`DriverID`, `DriverName`, `Car`) VALUES
(1, 'Liam', 'Audi'),
(2, 'Джеймс', 'Chevrolet'),
(3, 'Мэйсон', 'Mazda'),
(4, 'Джейкоб', 'Kia'),
(5, 'Оливер', 'Saab'),
(6, 'Лукас', 'BMW'),
(7, 'Джозеф', 'Toyota');

-- --------------------------------------------------------

--
-- Структура таблицы `Rating`
--

CREATE TABLE `Rating` (
  `Place` bigint(21) UNSIGNED NOT NULL DEFAULT '0',
  `DriverID` int(100) NOT NULL,
  `DriverName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `StageID` int(100) NOT NULL,
  `StageName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `TIME` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Rating`
--

INSERT INTO `Rating` (`Place`, `DriverID`, `DriverName`, `StageID`, `StageName`, `TIME`) VALUES
(1, 1, 'Liam', 1, 'Трасса Яс Марина', '2019-12-01 10:05:18.000000'),
(2, 2, 'Джеймс', 1, 'Трасса Яс Марина', '2019-12-01 10:05:21.000000'),
(3, 3, 'Мэйсон', 1, 'Трасса Яс Марина', '2019-12-01 10:05:24.000000'),
(4, 4, 'Джейкоб', 1, 'Трасса Яс Марина', '2019-12-01 10:05:27.000000'),
(5, 5, 'Оливер', 1, 'Трасса Яс Марина', '2019-12-01 10:05:30.000000');

-- --------------------------------------------------------

--
-- Структура таблицы `Results`
--

CREATE TABLE `Results` (
  `ResultID` int(11) NOT NULL,
  `StageID` int(100) NOT NULL,
  `CheckpoitID` int(100) NOT NULL,
  `DriverID` int(100) NOT NULL,
  `Time` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `Results`
--

INSERT INTO `Results` (`ResultID`, `StageID`, `CheckpoitID`, `DriverID`, `Time`) VALUES
(1, 1, 1, 1, '2019-12-01 10:00:03.000000'),
(2, 1, 1, 2, '2019-12-01 10:00:06.000000'),
(3, 1, 1, 3, '2019-12-01 10:00:09.000000'),
(4, 1, 1, 4, '2019-12-01 10:00:12.000000'),
(5, 1, 1, 5, '2019-12-01 10:00:15.000000'),
(6, 1, 2, 1, '2019-12-01 10:00:18.000000'),
(7, 1, 2, 2, '2019-12-01 10:00:21.000000'),
(8, 1, 2, 3, '2019-12-01 10:00:24.000000'),
(9, 1, 2, 4, '2019-12-01 10:00:27.000000'),
(10, 1, 2, 5, '2019-12-01 10:00:30.000000'),
(11, 1, 3, 1, '2019-12-01 10:00:33.000000'),
(12, 1, 3, 2, '2019-12-01 10:00:36.000000'),
(13, 1, 3, 3, '2019-12-01 10:00:39.000000'),
(14, 1, 3, 4, '2019-12-01 10:00:42.000000'),
(15, 1, 3, 5, '2019-12-01 10:00:45.000000'),
(16, 1, 4, 1, '2019-12-01 10:00:48.000000'),
(17, 1, 4, 2, '2019-12-01 10:00:51.000000'),
(18, 1, 4, 3, '2019-12-01 10:00:54.000000'),
(19, 1, 4, 4, '2019-12-01 10:00:00.000000'),
(20, 1, 4, 5, '2019-12-01 10:01:03.000000'),
(21, 1, 5, 1, '2019-12-01 10:01:06.000000'),
(22, 1, 5, 2, '2019-12-01 10:01:09.000000'),
(23, 1, 5, 3, '2019-12-01 10:01:12.000000'),
(24, 1, 5, 4, '2019-12-01 10:01:15.000000'),
(25, 1, 5, 5, '2019-12-01 10:01:18.000000'),
(26, 1, 6, 1, '2019-12-01 10:01:21.000000'),
(27, 1, 6, 2, '2019-12-01 10:01:24.000000'),
(28, 1, 6, 3, '2019-12-01 10:01:27.000000'),
(29, 1, 6, 4, '2019-12-01 10:01:30.000000'),
(30, 1, 6, 5, '2019-12-01 10:01:33.000000'),
(31, 1, 7, 1, '2019-12-01 10:01:36.000000'),
(32, 1, 7, 2, '2019-12-01 10:01:39.000000'),
(33, 1, 7, 3, '2019-12-01 10:01:42.000000'),
(34, 1, 7, 4, '2019-12-01 10:01:45.000000'),
(35, 1, 7, 5, '2019-12-01 10:01:48.000000'),
(36, 1, 8, 1, '2019-12-01 10:01:51.000000'),
(37, 1, 8, 2, '2019-12-01 10:01:54.000000'),
(38, 1, 8, 3, '2019-12-01 10:01:00.000000'),
(39, 1, 8, 4, '2019-12-01 10:02:03.000000'),
(40, 1, 8, 5, '2019-12-01 10:02:06.000000'),
(41, 1, 9, 1, '2019-12-01 10:02:09.000000'),
(42, 1, 9, 2, '2019-12-01 10:02:12.000000'),
(43, 1, 9, 3, '2019-12-01 10:02:15.000000'),
(44, 1, 9, 4, '2019-12-01 10:02:18.000000'),
(45, 1, 9, 5, '2019-12-01 10:02:21.000000'),
(46, 1, 10, 1, '2019-12-01 10:02:24.000000'),
(47, 1, 10, 2, '2019-12-01 10:02:27.000000'),
(48, 1, 10, 3, '2019-12-01 10:02:30.000000'),
(49, 1, 10, 4, '2019-12-01 10:02:33.000000'),
(50, 1, 10, 5, '2019-12-01 10:02:36.000000'),
(51, 1, 11, 1, '2019-12-01 10:02:39.000000'),
(52, 1, 11, 2, '2019-12-01 10:02:42.000000'),
(53, 1, 11, 3, '2019-12-01 10:02:45.000000'),
(54, 1, 11, 4, '2019-12-01 10:02:48.000000'),
(55, 1, 11, 5, '2019-12-01 10:02:51.000000'),
(56, 1, 12, 1, '2019-12-01 10:02:54.000000'),
(57, 1, 12, 2, '2019-12-01 10:02:00.000000'),
(58, 1, 12, 3, '2019-12-01 10:03:03.000000'),
(59, 1, 12, 4, '2019-12-01 10:03:06.000000'),
(60, 1, 12, 5, '2019-12-01 10:03:09.000000'),
(61, 1, 13, 1, '2019-12-01 10:03:12.000000'),
(62, 1, 13, 2, '2019-12-01 10:03:15.000000'),
(63, 1, 13, 3, '2019-12-01 10:03:18.000000'),
(64, 1, 13, 4, '2019-12-01 10:03:21.000000'),
(65, 1, 13, 5, '2019-12-01 10:03:24.000000'),
(66, 1, 14, 1, '2019-12-01 10:03:27.000000'),
(67, 1, 14, 2, '2019-12-01 10:03:30.000000'),
(68, 1, 14, 3, '2019-12-01 10:03:33.000000'),
(69, 1, 14, 4, '2019-12-01 10:03:36.000000'),
(70, 1, 14, 5, '2019-12-01 10:03:39.000000'),
(71, 1, 15, 1, '2019-12-01 10:03:42.000000'),
(72, 1, 15, 2, '2019-12-01 10:03:45.000000'),
(73, 1, 15, 3, '2019-12-01 10:03:48.000000'),
(74, 1, 15, 4, '2019-12-01 10:03:51.000000'),
(75, 1, 15, 5, '2019-12-01 10:03:54.000000'),
(76, 1, 16, 1, '2019-12-01 10:03:00.000000'),
(77, 1, 16, 2, '2019-12-01 10:04:03.000000'),
(78, 1, 16, 3, '2019-12-01 10:04:06.000000'),
(79, 1, 16, 4, '2019-12-01 10:04:09.000000'),
(80, 1, 16, 5, '2019-12-01 10:04:12.000000'),
(81, 1, 17, 1, '2019-12-01 10:04:15.000000'),
(82, 1, 17, 2, '2019-12-01 10:04:18.000000'),
(83, 1, 17, 3, '2019-12-01 10:04:21.000000'),
(84, 1, 17, 4, '2019-12-01 10:04:24.000000'),
(85, 1, 17, 5, '2019-12-01 10:04:27.000000'),
(86, 1, 18, 1, '2019-12-01 10:04:30.000000'),
(87, 1, 18, 2, '2019-12-01 10:04:33.000000'),
(88, 1, 18, 3, '2019-12-01 10:04:36.000000'),
(89, 1, 18, 4, '2019-12-01 10:04:39.000000'),
(90, 1, 18, 5, '2019-12-01 10:04:42.000000'),
(91, 1, 19, 1, '2019-12-01 10:04:45.000000'),
(92, 1, 19, 2, '2019-12-01 10:04:48.000000'),
(93, 1, 19, 3, '2019-12-01 10:04:51.000000'),
(94, 1, 19, 4, '2019-12-01 10:04:54.000000'),
(95, 1, 19, 5, '2019-12-01 10:04:00.000000'),
(96, 1, 20, 1, '2019-12-01 10:05:03.000000'),
(97, 1, 20, 2, '2019-12-01 10:05:06.000000'),
(98, 1, 20, 3, '2019-12-01 10:05:09.000000'),
(99, 1, 20, 4, '2019-12-01 10:05:12.000000'),
(100, 1, 20, 5, '2019-12-01 10:05:15.000000'),
(101, 1, 21, 1, '2019-12-01 10:05:18.000000'),
(102, 1, 21, 2, '2019-12-01 10:05:21.000000'),
(103, 1, 21, 3, '2019-12-01 10:05:24.000000'),
(104, 1, 21, 4, '2019-12-01 10:05:27.000000'),
(105, 1, 21, 5, '2019-12-01 10:05:30.000000');

--
-- Триггеры `Results`
--
DELIMITER $$
CREATE TRIGGER `OnDriverAdd_WhenDriversLimit` BEFORE INSERT ON `Results` FOR EACH ROW BEGIN
    IF ((SELECT COUNT(DISTINCT DriverID) FROM Results WHERE StageID = NEW.StageID) = 5 AND
        NOT EXISTS(SELECT 1 FROM Results WHERE Results.DriverID = NEW.DriverID AND Results.StageID = NEW.StageID)) THEN
        BEGIN
            SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = "Max amount of drivers for one race - '5'";
        END;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnDriverAdd_WhenPreviousCheckpointExists` BEFORE INSERT ON `Results` FOR EACH ROW BEGIN
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
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `Stage`
--

CREATE TABLE `Stage` (
  `StageID` int(100) NOT NULL,
  `StageName` text CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `Length` int(100) NOT NULL,
  `Checkpoints` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Дамп данных таблицы `Stage`
--

INSERT INTO `Stage` (`StageID`, `StageName`, `Length`, `Checkpoints`) VALUES
(1, 'Трасса Яс Марина', 5554, 21),
(2, 'Трасса Альберт-Парк', 5303, 16),
(3, 'Трасса Сахир', 5406, 15),
(4, 'Трасса Спа-Франкоршам', 6973, 21),
(5, 'Трасса Сильверстоун', 4309, 15),
(6, 'Трасса Валенсияя', 3507, 14),
(7, 'Трасса Нюрбургринг', 5148, 16),
(8, 'Трасса Сепанг', 5543, 15),
(9, 'Трасса Монте-Карло', 3340, 19),
(10, 'Трасса Марина Бей', 5073, 24);

-- --------------------------------------------------------

--
-- Структура таблицы `TotalRaceTimeForDriver`
--

CREATE TABLE `TotalRaceTimeForDriver` (
  `StageId` int(11) DEFAULT NULL,
  `StageName` varchar(100) DEFAULT NULL,
  `DriverId` int(11) DEFAULT NULL,
  `DriverName` varchar(100) DEFAULT NULL,
  `TimeInSeconds` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `TotalRaceTimeForDriver`
--

INSERT INTO `TotalRaceTimeForDriver` (`StageId`, `StageName`, `DriverId`, `DriverName`, `TimeInSeconds`) VALUES
(1, 'Трасса Яс Марина', 1, 'Liam', 315),
(1, 'Трасса Яс Марина', 2, 'Джеймс', 315),
(1, 'Трасса Яс Марина', 3, 'Мэйсон', 315),
(1, 'Трасса Яс Марина', 4, 'Джейкоб', 315),
(1, 'Трасса Яс Марина', 5, 'Оливер', 315);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Driver`
--
ALTER TABLE `Driver`
  ADD UNIQUE KEY `DriverID` (`DriverID`);

--
-- Индексы таблицы `Results`
--
ALTER TABLE `Results`
  ADD UNIQUE KEY `ResultID` (`ResultID`);

--
-- Индексы таблицы `Stage`
--
ALTER TABLE `Stage`
  ADD UNIQUE KEY `StageID` (`StageID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

