import mysql.connector
import click
from flask import current_app, g 
from flask.cli import with_appcontext



def get_db():
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="eshopdb"
    )

    return conn


