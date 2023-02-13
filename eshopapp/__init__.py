import os

import sqlalchemy
from flask import Flask
from flask_admin import Admin
from flask_sqlalchemy import SQLAlchemy, Model
from sqlalchemy import MetaData, Table

from eshopapp.db import get_db
from sqlalchemy.ext.declarative import declarative_base
from flask_admin.contrib.sqla import ModelView


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev'
    )
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    app.config['SQLALCHEMY_DATABASE_URI'] = "mysql+pymysql://root:root@127.0.0.1:3306/eshopdb"

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    engine = sqlalchemy.create_engine("mysql+pymysql://root:root@127.0.0.1:3306/eshopdb")
    db = SQLAlchemy(app)
    #connection = engine.connect()
    #metadata = sqlalchemy.MetaData()
    #item = sqlalchemy.Table('item', metadata, autoload=True, autoload_with=engine)
    Base = declarative_base()
    Base.metadata.reflect(engine)
    admin = Admin(app)

    from sqlalchemy.orm import relationship, backref
    class Item(db.Model):
        __table__ = Base.metadata.tables['item']


    class User(db.Model):
        __table__ = Base.metadata.tables['user']

    class Category(db.Model):
        __table__ = Base.metadata.tables['category']

    class Cart(db.Model):
        __table__ = Base.metadata.tables['cart']
        itemid = relationship("Item")

    class Review(db.Model):
        __table__ = Base.metadata.tables['reviews']
        itemrev = relationship("Item")
        userref = relationship("User")

    class ItemMedia(db.Model):
        __table__ = Base.metadata.tables['item_media']
        item1 = relationship("Item")

    class Order1(db.Model):
        __table__ = Base.metadata.tables['order']
        user1 = relationship("User")

    class Order_Item(db.Model):
        __table__ = Base.metadata.tables['order_item']
        order1 = relationship("Order1")
        item2 = relationship("Item")

    admin.add_view(ModelView(Item, db.session))
    admin.add_view(ModelView(User, db.session))
    admin.add_view(ModelView(Category, db.session))
    admin.add_view(ModelView(Cart, db.session))
    admin.add_view(ModelView(Review, db.session))
    admin.add_view(ModelView(ItemMedia, db.session))
    admin.add_view(ModelView(Order1, db.session))
    admin.add_view(ModelView(Order_Item, db.session))
    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # a simple page that says hello
    @app.route('/hello')
    def hello():
        return 'Hello, World!'
    
    from . import auth
    app.register_blueprint(auth.bp)

    #from . import blog
    #app.register_blueprint(blog.bp)
    #app.add_url_rule('/', endpoint='index')

    from . import mainpage
    app.register_blueprint(mainpage.bp)
    app.add_url_rule('/', endpoint='index')

    from . import orderpage
    app.register_blueprint(orderpage.bp)
    app.add_url_rule('/Order', endpoint='order')

    return app