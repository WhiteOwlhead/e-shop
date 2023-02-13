from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for
)
from werkzeug.exceptions import abort

from eshopapp.auth import login_required
from eshopapp.db import get_db

bp = Blueprint('blog', __name__)

@bp.route('/')
def index():
    db = get_db()
    db.execute(
        'SELECT item_ID, Name, In_stock'
        ' FROM item'
        ' ORDER BY Name DESC'
    )
    posts = db.fetchall()
    return render_template('mainpage/mainpage.html', posts=posts)