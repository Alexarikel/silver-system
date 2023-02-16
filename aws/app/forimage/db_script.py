import os
import os.path
import sys
from S3_bucket import S3_bucket
import logging
import subprocess

logger = logging.getLogger(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format="%(asctime)s:%(name)s:%(funcName)s:%(message)s")

stream_handler = logging.StreamHandler()
logger.addHandler(stream_handler)

ACCESSID = os.environ["ACCESSID"]
ACCESSKEY = os.environ["ACCESSKEY"]
BUCKET = os.environ["BUCKET"]
USER = os.environ["USER"]
PASSWORD = os.environ["PASSWORD"]
HOST = os.environ["HOST"]
PORT = os.environ["PORT"]
DATABASE = os.environ["DATABASE"]
UPDATED = os.environ["UPDATED"]


if __name__ == "__main__":
    client_bucket = S3_bucket(BUCKET, ACCESSID, ACCESSKEY)
    list_bucket = client_bucket.list_bucket()
    for i in list_bucket:
        client_bucket.download(i, i)
        print(f"Importing {i}")
        subprocess.run(f"mysql -h {HOST} -u {USER} --password={PASSWORD} < {i}", shell=True)
    print("Done")
