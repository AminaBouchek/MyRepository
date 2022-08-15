Connection to wissal group dev server with remmina:
connect with SSH to adress "ec2-3-9-25-94.eu-west-2.compute.amazonaws.com"
and the file.

1- try an external Connection on local
    psql -h 3.9.25.94 -p 6432 -U tkdev -d dbtkdev
2- if cannot connect:
    - check internet Connection
    - or check server (eather the machine is off or adress changed) 
3- when server is reachable, connect with psql 
    - always check services (postgres and pgbouncer) restart services if necessery:
        (sudo service postgresql/pgbouncer restart)
4- if cannot connect with psql,
    - check disk (commande: df -h)
    - if full, add space (from AWS witch is not your job)
    - add the space to the parition with the commande:
         sudo growpart /dev/disk_name partition_number
    - reboot server: (commande: reboot)
    - check disk and partition (commande: lsblk)

commandes: 
- lsblk = show disk and partitions
- du = show disk usage

create new user:
    - create a role (CREATE ROLE role_name options)
    - connect with postgres, show authontification table
        select * from pg_category_authid;
    - get enrypted password for the new user created
    - browse to /etc/pgbouncer
    - add the password to the file "pgbouncer.ini"  
    - browse to /etc/postgresql/12/main/
    - add the new user to the file pg_hba.conf
    - restart services: sudo service postgresql restart)
