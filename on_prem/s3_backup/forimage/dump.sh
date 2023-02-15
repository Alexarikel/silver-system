#!/bin/bash
mysqldump -h ${host} -u ${user} --password=${root_pass} --databases ${database} -r ${BACKUP}
eval ${1}
