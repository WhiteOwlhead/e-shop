from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for, session
)
from werkzeug.exceptions import abort
from datetime import datetime
from eshopapp.auth import login_required
from eshopapp.db import get_db

bp = Blueprint('order', __name__)

@bp.route('/Order', methods=('GET', 'POST'))
def order():
    data = {}
    conn = get_db()
    db = conn.cursor()
    user_id = session.get('user_id')
    itemsquerr = f'SELECT item.item_ID, item.item_name, item_media.item_media_path, cart.user, ' \
                 f'cart.item, cart.quantity FROM item INNER JOIN ' \
                 f'item_media ON item.item_ID = item_media.item INNER JOIN cart on cart.item = ' \
                 f'item.item_ID WHERE cart.user = {user_id}'

    db.execute(itemsquerr)
    posts = db.fetchall()

    return render_template('orderpage/orderpage.html', posts=posts)

@bp.route('/Basket', methods=('GET', 'POST'))
def basket():
    data = {}
    conn = get_db()
    db = conn.cursor()
    user_id = session.get('user_id')
    itemsquerr = f'SELECT item.item_ID, item.item_name, item_media.item_media_path, cart.user, ' \
                 f'cart.item, cart.quantity FROM item INNER JOIN ' \
                 f'item_media ON item.item_ID = item_media.item INNER JOIN cart on cart.item = ' \
                 f'item.item_ID WHERE cart.user = {user_id}'

    db.execute(itemsquerr)
    posts = db.fetchall()

    return render_template('orderpage/basketpage.html', posts=posts)

@bp.route('/Basket/DeleteRecord', methods=('GET','POST'))
def deleteRecordBasket():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    deletequerr = f'DELETE FROM cart WHERE cart.item = {item_ID}'
    db.execute(deletequerr)
    conn.commit()
    return redirect('/Basket')

@bp.route('/Basket/ReduceQuant', methods=('GET','POST'))
def reduceQuantBasket():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    selectquerr = f'SELECT quantity FROM cart WHERE cart.item = {item_ID}'
    db.execute(selectquerr)
    selectVal = db.fetchall()

    if selectVal[0][0] == 1:
        deletequerr = f'DELETE FROM cart WHERE cart.item = {item_ID}'
        db.execute(deletequerr)
        conn.commit()

    else:
        updatequerr = f'UPDATE cart SET quantity = quantity - 1 WHERE item = {item_ID}'
        db.execute(updatequerr)
        conn.commit()

    print(selectVal)
    print(selectVal[0][0])
    return redirect('/Basket')

@bp.route('/Basket/AddQuant', methods=('GET','POST'))
def addQuantBasket():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    updatequerr = f'UPDATE cart SET quantity = quantity + 1 WHERE item = {item_ID}'
    db.execute(updatequerr)
    conn.commit()
    return redirect('/Basket')

@bp.route('/Order/DeleteRecord', methods=('GET','POST'))
def deleteRecord():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    deletequerr = f'DELETE FROM cart WHERE cart.item = {item_ID}'
    db.execute(deletequerr)
    conn.commit()
    return redirect('/Order')

@bp.route('/Order/ReduceQuant', methods=('GET','POST'))
def reduceQuant():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    selectquerr = f'SELECT quantity FROM cart WHERE cart.item = {item_ID}'
    db.execute(selectquerr)
    selectVal = db.fetchall()

    if selectVal[0][0] == 1:
        deletequerr = f'DELETE FROM cart WHERE cart.item = {item_ID}'
        db.execute(deletequerr)
        conn.commit()

    else:
        updatequerr = f'UPDATE cart SET quantity = quantity - 1 WHERE item = {item_ID}'
        db.execute(updatequerr)
        conn.commit()

    print(selectVal)
    print(selectVal[0][0])
    return redirect('/Order')

@bp.route('/Order/AddQuant', methods=('GET','POST'))
def addQuant():
    conn = get_db()
    db = conn.cursor()
    item_ID = request.args.get('item_ID')
    updatequerr = f'UPDATE cart SET quantity = quantity + 1 WHERE item = {item_ID}'
    db.execute(updatequerr)
    conn.commit()
    return redirect('/Order')

@bp.route('/Order/Done', methods=('GET', 'POST'))
def orderDone():
    conn = get_db()
    db = conn.cursor()
    today = datetime.today()
    user_id = session.get('user_id')

    createquerr = f'INSERT INTO eshopdb.order (order.user, order.order_date, order.delivery_type) ' \
                  f'VALUES ({user_id}, now(), 3); '
    db.execute(createquerr)
    conn.commit()

    orderidquerr = f'SELECT LAST_INSERT_ID();'
    db.execute(orderidquerr)
    orderid = db.fetchall()
    print(orderid)

    itemsquerr = f'SELECT * from cart WHERE cart.user = {user_id} '


    db.execute(itemsquerr)
    items = db.fetchall()

    for item in items:
        insertquerr = f'INSERT INTO order_item (order_item.order_ID, order_item.item, ' \
                      f'order_item.quantity) VALUES ({orderid[0][0]}, {item[1]}, {item[2]}) '
        db.execute(insertquerr)
        conn.commit()
        deletequerr = f'DELETE FROM cart WHERE cart.user = {user_id} AND cart.item = {item[1]}'
        #delete basket item
        db.execute(deletequerr)
        conn.commit()


    return redirect("/")