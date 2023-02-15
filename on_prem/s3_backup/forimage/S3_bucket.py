from asyncio.log import logger
import boto3
import logging
import os
import sys

logger = logging.getLogger(__name__)
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format="%(asctime)s:%(name)s:%(funcName)s:%(message)s")

class S3_bucket:
    def __init__(self, bucket, accessid, accesskey):
        self.bucket = bucket
        self.accesskey = accesskey
        self.accessid = accessid
        self.s3_client = self.session()

    def session(self):
        try:
            s3_client = boto3.client('s3', aws_access_key_id=self.accessid, aws_secret_access_key=self.accesskey)
        except Exception as e:
            logger.exception(f"Connection failed.  Error: {e}")
        else:
            logger.info("Connected to s3 bucket.")
            return s3_client

    def list_bucket(self):
        objects = self.s3_client.list_objects_v2(Bucket=self.bucket)
        list_bucket = []
        for obj in objects['Contents']:
            obj = obj['Key']
            list_bucket.append(obj)
        return list_bucket

    def download (self, file_name, file_to_save):
        try:
            self.s3_client.download_file(self.bucket, file_name, file_to_save)
        except Exception as e:
            logger.exception(f"An error occured while downloading files. Error: {e}")
        else:
            logger.info("Downloaded successfully.")

    def upload (self, file_to_upload, obj_name = None):
        if obj_name is None:
            obj_name = os.path.basename(file_to_upload)
        try:
            self.s3_client.upload_file(file_to_upload, self.bucket, obj_name)
        except Exception as e:
            logger.exception(f"An error occured while uploading files. Error: {e}")
        else:
            logger.info("Downloaded successfully.")
