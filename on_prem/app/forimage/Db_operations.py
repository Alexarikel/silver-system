#!/usr/bin/env python

import mariadb
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(filename="db_script.log", level=logging.INFO, format="%(asctime)s:%(name)s:%(funcName)s:%(message)s")

class Db_operations:
    def __init__(self, user, password, host, port, database):
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.database = database
        self.conn = self.connection()

    def connection (self):
        try:
            conn = mariadb.connect(
                user = self.user,
                password = self.password,
                host = self.host,
                port = self.port,
                database = self.database
            )
        except Exception as e:
            logger.exception(f"Connection failed. Error: {e}")
        else:
            logger.info("Connected to database.")
            return conn

    def insert_from_file (self, table, file_name):
        with open (file_name, mode="r") as downloaded:
            for line in downloaded.readlines():
                try:
                    line = line.strip().split(",")
                    sqlquery = f"INSERT INTO {table} VALUES {*line,}"
                    curr = self.conn.cursor()
                    curr.execute(sqlquery)
                except Exception as e:
                    logger.exception(f"An error occured while inserting data. Error: {e}")
                    return False
                else:
                    logger.info("Inserted successfully.")
            self.conn.commit()

    def insert_from_html (self, table, form):
        line = []
        row = ""
        for i in form:
            row = row + i[0] + ","
            line.append(i[1])
        row = row[:-1]

        try:
            sqlquery = f"INSERT INTO {table} ({row}) VALUES {*line,}"
            print(sqlquery)
            curr = self.conn.cursor()
            curr.execute(sqlquery)
        except Exception as e:
            logger.exception(f"An error occured while inserting data. Error: {e}")
            return False
        else:
            logger.info("Inserted successfully.")
        self.conn.commit()
