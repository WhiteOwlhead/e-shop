from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, session
)
from werkzeug.exceptions import abort

from eshopapp.auth import login_required
from eshopapp.db import get_db

bp = Blueprint('mainpage', __name__)

@bp.route('/', methods=('GET', 'POST'))
def index():
    data = {}
    conn = get_db()
    db = conn.cursor()
    itemsquerr = 'SELECT item.item_ID, item.item_name, item.in_stock, item_media.item_media_path FROM eshopdb.item INNER JOIN ' \
                 'item_media ON item.item_ID = item_media.item '

     #SELECT categories.category_ID, categories.category_name, categories.category_description, item.item_ID, item.Name, item.In_stock, item_media.item_media_path FROM mydb.categories INNER JOIN item on item.Categories_categories_ID = categories.category_ID INNER JOIN item_media ON item.item_ID = item_media.Item_item_ID
    if request.method == 'GET':
        category_ID = request.args.get('category_ID')
        if category_ID:
            itemsquerr += f'WHERE item.category = {category_ID}'
    db.execute(itemsquerr)
    posts = db.fetchall()
    db.execute('SELECT * FROM category')
    categories = db.fetchall()
    user_id = session.get('user_id')
    print(user_id)
    data = {'categories': categories,
            'posts': posts, 'user': user_id}

    return render_template('mainpage/mainpage.html', data=data)

@bp.route('/Item', methods=('GET', 'POST'))
def item():
    conn = get_db()
    db = conn.cursor()
    if request.method == 'GET':
        item_ID = request.args.get('item_ID')
        if item_ID:
            itemsquerr = f'SELECT category.category_ID, category.category_name, category.category_description, ' \
                         f'item.item_ID, item.item_name, item.in_stock, item_media.item_media_path, item.item_price FROM eshopdb.category ' \
                         f'INNER JOIN item on item.category = category.category_ID INNER JOIN ' \
                         f'item_media ON item.item_ID = item_media.item WHERE item.item_ID = {item_ID} '

            db.execute(itemsquerr)
            item = db.fetchall()
            itemsquerr1 = f'SELECT item.item_ID, reviews.review_ID, reviews.review_rating, reviews.review_description ' \
                         f'FROM eshopdb.reviews INNER JOIN item on item.item_ID = reviews.item WHERE ' \
                         f'item.item_ID = {item_ID} '
            db.execute(itemsquerr1)
            reviews = db.fetchall()
            itemsquerr2 = f'SELECT AVG(review_rating) FROM reviews INNER JOIN item on item.item_ID = reviews.item WHERE item.item_ID = {item_ID}'
            db.execute(itemsquerr2)
            avgreview = db.fetchall()

            data = {'item': item, 'reviews': reviews, 'avg': avgreview[0] }


    return render_template('mainpage/itempage.html', data=data)

@bp.route('/AddToBasket', methods=('GET', 'POST'))
def addToBasket():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    selectquerr = f"SELECT user, item, quantity, price FROM cart WHERE " \
                  f"cart.user = {session.get('user_id')} AND cart.item = {item_ID} AND " \
                  f"cart.quantity != 0 "

    db.execute(selectquerr)
    select = db.fetchall()
    if select.__len__() == 0 :
        itemquerr = f"INSERT INTO cart(user, item, quantity, price) VALUES ({session.get('user_id')}, {item_ID}, 1, 22)"
        db.execute(itemquerr)
        conn.commit()
    else:
        updatequerr = f'UPDATE cart SET quantity = quantity + 1 WHERE item = {item_ID}'
        db.execute(updatequerr)
        conn.commit()

    return redirect("/")
