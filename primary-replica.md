# MySQL Replication  - Master & Slave

## Requirements
- 2 nodes (at least) - 1 Source (Primary) & 1 Replica
- Ensure they are fully ready. Meaning, mysql is installed and correctly running in both nodes.
- If needed, mysql's `data-dir` is configured to use an expandable volume.
- MySQL 8.0.4x
- Linux (assumes debian based)
- Extra volume to copy backup data in the same node. This guide assumes the volume is mounted in `/mnt/mysql_extra`
- MySQL specific config like (in my.cnf; possibly in /etc/mysql/mysql.conf.d/mysqld.cnf)
- root/sudo access on all nodes

## Setup Steps
- Configure creds (creds.env) and provide all credentials
- Run prepare_master.sh
- Run prepare_slave.sh
- Run clone_and_replicate_on_slave.sh in each slave

## Prepare Master
- Run `prepare_master.sh` script that will set up the mysql config so it can be cloned and treated as master

## Prepare Slave(s)
- Run `prepare_slave.sh` which will set server-id and other setup in slave mysql config

## Clone & Replicate
This step will clone the entire mysql instance. **Remember, any data/databases on the recipient (slave) will be destroyed.**

Run `./clone_and_replicate_on_slave.sh`

