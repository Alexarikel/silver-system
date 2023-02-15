import os
import os.path
import sys
from S3_bucket import S3_bucket
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format="%(asctime)s:%(name)s:%(funcName)s:%(message)s")

stream_handler = logging.StreamHandler()
logger.addHandler(stream_handler)

ACCESSID = os.environ["ACCESSID"]
ACCESSKEY = os.environ["ACCESSKEY"]
BUCKET = os.environ["BUCKET"]
BACKUP = os.environ["BACKUP"]


READ_AND_APPEND = "a+"

if __name__ == "__main__":
    client_bucket = S3_bucket(BUCKET, ACCESSID, ACCESSKEY)
    client_bucket.upload(BACKUP)
