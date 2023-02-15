# silver-system
Infrastructure and data transferring process between unrelated companies

### The project immitates ETL process of data transfer between unrelated companies using third party resource - S3 bucket.
---

#### The project schema:

<br/>![schema](https://github.com/DevopsAutumn2022/silver-system/blob/main/project_schema.PNG)

#### Stack of technologies:
- Terraform
- Ansible
- Python
- FastAPI
- HTML
- Jenkins
- Docker
- VmWare
- AWS (VPC, EC2, S3 bucket, AWS RDS)
- MariaDB databases
- Bash
---

Project consists of two separete parts and a S3 bucket resource between them.

**On_prem** folder content raises an infrastracture in VmWare, deploys application to 
application server, sends data received by the application from user to database server 
and every hour makes data backup and sends it to s3 backet.

**AWS** folder content raises an infrastracture in AWS Cloud, deploys application to 
application server, and every hour restores data from s3 bucket to RDS instanse. 


