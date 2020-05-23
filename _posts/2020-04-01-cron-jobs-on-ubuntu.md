---
title: Set up cron jobs on Ubuntu
header:
  image: assets/images/header-images/IMG_8436_w2500.jpeg
categories:
  - Crib Sheets
tags:
  - linux
  - ubuntu
---
* <https://help.ubuntu.com/community/CronHowto/> is very useful

#### Basic steps

* put a script or symlink in `/etc/cron.hourly/`, `/etc/cron.daily/`, `/etc/cron.weekly/`, or `/etc/cron.monthly/` as appropriate
    * NOTE: On Ubuntu, there must NOT be any dots in the filename, so that means no file extensions
* You can test what scripts will be run for each one with this command (or similar):
  ```bash
  run-parts --test /etc/cron.hourly
  ```

* Check whether cron daemon is running:
  ```bash
  sudo status cron
  ```

* Check log file for cron related entries (note the '-i' for case-insensitive):
  ```bash
  grep -i cron /var/log/syslog
  ```

* NOTE: There is no log of output from cron jobs. You need to handle that on a per script basis, or change the logging config.
