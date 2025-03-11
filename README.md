# MySQL Replication  - Primary & Replica


## Requirements
- 2 nodes (at least) - 1 Source (Primary) & 1 Replica
- Ensure they are fully ready. Meaning, mysql is installed and correctly running in both nodes.
- If needed, mysql's `data-dir` is configured to use an expandable volume.
- MySQL 8.0.4x
- Linux (assumes debian based)
- Extra volume to copy backup data in the same node. This guide assumes the volume is mounted in `/mnt/mysql_extra`
- MySQL specific config like (in my.cnf; possibly in /etc/mysql/mysql.conf.d/mysqld.cnf)
- root/sudo access on all nodes
- You need to populate `.env` before running the script. The following creds are required

```
export DONOR_HOST="<IP>"
export REPL_USER="<USER>"
export REPL_PASS="<PASSWORD>"
export RECIPIENT_ADMIN_USER="<ADMIN_USER>"
export RECIPIENT_ADMIN_PASS="<PASSWORD>"
export RECIPIENT_HOST="<HOST>"
```


## Setup Steps
- Configure creds (.env) and provide all credentials

## Clone & Replicate
This step will clone the entire mysql instance. **Remember, any data/databases on the recipient (replica) will be destroyed.**

Run `./clone_and_replicate_on_replica.sh`

