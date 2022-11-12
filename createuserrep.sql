CREATE USER glpi_rep@'%' IDENTIFIED BY 'R3p0r7eS_6lp!';
GRANT SELECT ON glpi.* to glpi_rep@'%';
FLUSH PRIVILEGES;
