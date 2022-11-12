update glpi_crontasks set state=1 where id=9 and state=2 and lastrun<= adddate(now(),interval -4 minute);
