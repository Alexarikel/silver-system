#!/usr/bin/env python

from fastapi.responses import HTMLResponse
from fastapi import FastAPI, Request
from fastapi.templating import Jinja2Templates
from fastapi import Form
from pydantic import BaseModel
import mariadb
from Db_operations import Db_operations
import os

app = FastAPI()

templates = Jinja2Templates(directory="templates")

@app.get("/form/", response_class=HTMLResponse)
async def form(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

class Patient(BaseModel):
    doctor:str
    department:str
    first_name:str
    last_name:str
    age:str
    cost:int

USER = os.environ["USER"]
PASSWORD = os.environ["PASSWORD"]
HOST = os.environ["HOST"]
PORT = int(os.environ["PORT"])
DATABASE = os.environ["DATABASE"]
TABLE = os.environ["TABLE"]

@app.post("/submit/", response_model=Patient)
async def submit(doctor: str = Form(...), department: str = Form(...), first_name: str = Form(...), last_name: str = Form(...), age: str = Form(...), cost: int = Form(...)):
    db_conn = Db_operations(USER, PASSWORD, HOST, PORT, DATABASE)
    obj = Patient(doctor=doctor, department=department, first_name=first_name, last_name=last_name, age=age, cost=cost)
    db_conn.insert_from_html(TABLE, obj)
    db_conn.conn.close()
    return obj
