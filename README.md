# MySql-Experiments
Triggers, Procedures, Cursors, BlackJack &amp; B*tches

Условия и решения задачек:
* Cоздать таблицу Rating на основе Results с колонками StageId, StageName, DriverName Time, лидерборд  
[Solution](/CreateRatingTable.sql)
* Написать триггер, который не позволяет вводить гонщика в таблицу, если сошел с дистанции (не прошел checkpoint)  
[Solution](/OnDriverAdd_WhenPreviousCheckpointExists.sql)
* Написать процедуру - результат гонщика(driverId) для гонки(stageId) поэтапно со временем (Вида: трасса - checkpoint - время)  
[Solution](/DriverStat.sql)
* Используя данные о заездах построить динамичный курсор, который показывает трассу, водителя и время в секундах, за которое водитель прошел гонку.  
[Solution](/GetTotalDriversTimeForStage.sql)
* Построить триггер FOR на таблицу участников гонки, запрещающий вводить нового участника, если участников уже больше N  
[Solution](/OnDriverAdd_WhenDriversLimit.sql)
