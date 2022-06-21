#!/bin/bash
HOST=127.0.0.1
USER=herc01
PASSWORD=CUL8TR

ftp -inv $HOST 2100  <<EOF
user $USER $PASSWORD
cd herc01.test.seq
put TEACHER TEACHER
bye
EOF