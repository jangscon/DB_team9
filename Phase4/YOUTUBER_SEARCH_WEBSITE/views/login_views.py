from flask import Blueprint, render_template

login_bp = Blueprint('login', __name__)

@login_bp.route("/")
def login_page():
    # return render_template('login.html')
    return render_template('info_page.html')