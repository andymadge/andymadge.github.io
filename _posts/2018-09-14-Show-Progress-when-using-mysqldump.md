---
title: Show Progress when using mysqldump
header:
  image: assets/images/header-images/IMG_8424_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - mysql
  - linux
---
`mysqldump` doesn't show progress natively, but you can use the [pv utility](https://linux.die.net/man/1/pv) to show progress.

PV is used by inserting it in the pipeline

If you start off with this command line:

```bash
mysqldump -u root -p --add-drop-database --extended-insert --opt --databases odw | gzip -c > /tmp/odw.sql.gz
```

you would then add pv like this:

```bash
mysqldump -u root -p --add-drop-database --extended-insert --opt --databases odw | pv -W -s 16g | gzip -c > /tmp/odw.sql.gz
```

`-W`   means don't display anything until first byte is received. This is important if there is some processing happening before data transfer

`-s 16g`   means start with an estimated size of 16 GB.  

The best way to estimate the total size is to check the database size and use 80% of that figure.  It won't be spot on but it will be in the right ballpark.

You can check database sizes with this query (will return size of all DBs on the server):

```sql
SELECT 
    table_schema AS 'Database',
    SUM(data_length + index_length) / 1024 / 1024 AS 'Size (MB)'
FROM
    information_schema.TABLES
GROUP BY table_schema
```