import os
import sys
# import cx_Oracle
from flask import Flask

# 터미널에 이거 필수로 해줘야 함
# $ export PYTHON_USERNAME= ID
# $ export PYTHON_PASSWORD= PASSWORD
# $ export PYTHON_CONNECTSTRING= IP:PORT/서비스이름

# def init_session(connection, requestedTag_ignored):
#     cursor = connection.cursor()
#     cursor.execute("""
#         ALTER SESSION SET
#           TIME_ZONE = 'UTC'
#           NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI'""")



# def start_pool():
#
#     # Generally a fixed-size pool is recommended, i.e. pool_min=pool_max.
#     # Here the pool contains 4 connections, which is fine for 4 concurrent
#     # users.
#     #
#     # The "get mode" is chosen so that if all connections are already in use, any
#     # subsequent acquire() will wait for one to become available.
#
#     pool_min = 4
#     pool_max = 4
#     pool_inc = 0
#     pool_gmd = cx_Oracle.SPOOL_ATTRVAL_WAIT
#
#     print("Connecting to", os.environ.get("PYTHON_CONNECTSTRING"))
#
#     pool = cx_Oracle.SessionPool(user=os.environ.get("PYTHON_USERNAME"),
#                                  password=os.environ.get("PYTHON_PASSWORD"),
#                                  dsn=os.environ.get("PYTHON_CONNECTSTRING"),
#                                  min=pool_min,
#                                  max=pool_max,
#                                  increment=pool_inc,
#                                  threaded=True,
#                                  getmode=pool_gmd,
#                                  sessionCallback=init_session)
#
#     return pool

def create_app():

    # if sys.platform.startswith("darwin"):
    #     cx_Oracle.init_oracle_client(lib_dir=os.environ.get("HOME") + "/instantclient_19_3")
    # elif sys.platform.startswith("win32"):
    #     cx_Oracle.init_oracle_client(lib_dir=r"c:\oracle\instantclient_19_8")

    app = Flask(__name__)

    from .views import login_views , main_views
    app.register_blueprint(login_views.login_bp, url_prefix="/login")
    app.register_blueprint(main_views.main_bp, url_prefix="/main")

    return app
