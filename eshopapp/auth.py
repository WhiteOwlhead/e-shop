import functools

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from eshopapp.db import get_db

bp = Blueprint('auth', __name__, url_prefix='/auth')



@bp.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        name = request.form['name']
        surname = request.form['surname']
        email = request.form['email']
        conn = get_db()
        db = conn.cursor()
        error = None

        if not login:
            error = 'Login is required.'
        elif not password:
            error = 'Password is required.'

        if error is None:
            try:
                db.execute(
                    "INSERT INTO user (name, surname, login, password, email, user_role) VALUES (%s, %s, %s, %s, %s, %s)",
                    (name, surname, login, password, email, "4")
                )
                conn.commit()
            except Exception as e:
                error = f"User {login} is already registered."
                print(e)
            else:
                return redirect(url_for("auth.login"))

        flash(error)

    return render_template('auth/register.html')

@bp.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        login = request.form['login']
        password = request.form['password']
        conn = get_db()
        db = conn.cursor()
        error = None
        print(db)
        db.execute(
            'SELECT * FROM user WHERE login = %s AND password = %s', (login, password)
        )
        user = db.fetchone()
        print(user)
        if user is None:
            error = 'Incorrect login.'
        elif not (user[5], password):
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user[0]
            return redirect(url_for('index'))

        flash(error)

    return render_template('auth/login.html')

@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        conn = get_db()
        db = conn.cursor()
        db.execute(
            'SELECT * FROM user WHERE user_ID = %s', (user_id,)
        )
        g.user = db.fetchone()

@bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('index'))

def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('auth.login'))

        return view(**kwargs)

    return wrapped_view
