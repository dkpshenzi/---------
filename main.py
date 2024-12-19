from flask import Flask, render_template, request, redirect, url_for, session,jsonify
from flask_mysqldb import MySQL
from utils import query
import re
import time
from flask_cors import CORS
from config import outkey,forbidden_keys
import config
from utils.query import tprint
import json
import datetime

app = Flask(__name__)
app.secret_key = "dkp"
CORS(app)   # 允许跨域请求

# 初始化MySQL
mysql = MySQL(app)

@app.route('/', methods=['GET', 'POST'])
def login():
    msg = ''
    # 检查是否存在请求
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']
        # 检查账户是否存在于MYSQL中
        sql = f"SELECT * FROM user WHERE Account = '{username}' AND Password = '{password}'"
        tprint(sql)
        if account := query.query(sql):
            account = account[0]
            # 创建会话数据——这个是全局的会话数据没来判断用户是否已经登录以及一些其他的信息
            session['loggedin'] = True
            session['id'] = account['UserId']
            session['username'] = account['Account']
            # 重定向到网页
            return redirect(url_for('home'))
        else:
            # 账户不存在或用户名/密码不正确
            msg = 'Incorrect username/password!'
    # 显示带有消息的登录表单
    return render_template('index.html', msg=msg)

@app.route('/logout')
def logout():
    # 删除会话数据，会使得用户注销
    session.pop('loggedin', None)
    session.pop('id', None)
    session.pop('username', None)
    # 重定向到登录页面
    return redirect(url_for('login'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form:
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        # 检查帐户是否存在MySQL中
        sql = f"SELECT * FROM user WHERE Account = '{username}'"
        account = query.query(sql)
        # 如果账户存在，则显示错误和验证检查
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+',email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+',username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password or not email:
            msg = 'Please fill out the form!'
        else:
            sql = f"INSERT INTO user VALUES (NULL,'Worker','{username}','{password}',NULL,'{email}')"
            query.update(sql)
            msg = '成功注册！'
    elif request.method == 'POST':
        # 表单为空，没有post数据
        msg = 'Please fill out the form!'
    return render_template('register.html', msg=msg)

@app.route('/home')
def home():
    if 'loggedin' in session:
        # 用户已登录并显示主页
        return render_template('home.html', username=session['username'])
    # 用户未登录，重定向到登录页面
    return redirect(url_for('login'))

@app.route('/view')
def view():
    if 'loggedin' in session:
        # 用户已登录并显示主页
        return render_template('view.html', username=session['username'])
    # 用户未登录，重定向到登录页面
    return redirect(url_for('login'))

@app.route('/profile')
def profile():
    if 'loggedin' in session:
        # 我们需要用户的所有账户信息
        sql = f"SELECT * FROM user WHERE Userid = '{session['id']}'"
        account = query.query(sql)[0]
        return render_template('profile.html', account=account)
    return redirect(url_for('login'))

@app.route('/api/get_data',methods=['POST'])
def get_data():
    try:
        data = request.get_json()
        if not data or 'table' not in data:
            return jsonify({'message': 'Mssing table name!'}),400
        table = data['table']

        sql = f"SELECT * FROM {table}"
        tprint(sql)
        result = query.query(sql,session)
        sql = f"DESCRIBE {table}"
        # 如果是timedelta，则需要转换成字符串
        for row in result:
            for key, value in row.items():
                if isinstance(value, datetime.timedelta):
                    row[key] = str(value)
                if isinstance(value, datetime.date):
                    row[key] = value.strftime("%Y-%m-%d")

        columns = [col['Field'] for col in query.query(sql,session)]
        return jsonify({'columns':columns,'data':result}),200
    except Exception as e:
        return jsonify({"message": f"获取数据出错——{str(e)}"}), 400

@app.route('/api/update_data',methods=['POST'])
def update_data():
    # 判断管理员身份
    tableNames = query.get_visibleTables(session)

    try:
        data = request.get_json()
        # 因为要对实际的表格进行修改所以需要转换成实际的表格名
        table = tableNames.get(data.get('table'))[1]

        update_data = data.get('data')
        primary_key = data.get('primaryKey')
        primary_key_value = query.value_change(data.get('primaryKeyValue'))

        if not all([table, update_data, primary_key, primary_key_value]):
            return jsonify({"message": "Missing required fields"}), 400

        update_data = query.view_to_table(table,update_data,session)

        # 判读是否为纯数字列
        set_clause = ", ".join(
                    [f"{key} = {value if value.isnumeric() else (repr(value) if value else 'NULL')}"
                     for key, value in update_data.items()]
            )
        sql = f"UPDATE {table} SET {set_clause} WHERE {primary_key} = {primary_key_value}"
        query.update(sql,session)
        tprint(sql)
        return jsonify({'message': 'Data updated successfully!'}),200
    except Exception as e:
        return jsonify({"message":str(e)}),400

@app.route('/api/delete_data',methods=['POST'])
def delete_data():
    tableNames = query.get_visibleTables(session)
    try:
        data = request.get_json()
        table = tableNames.get(data.get('table'))[1]
        primary_key = data.get('primary_key')
        primary_key_value = data.get('primary_key_value')

        if not all([table, primary_key, primary_key_value]):
            return jsonify({"message": "Missing required fields"}), 400


        sql1 = f"DELETE FROM {table} WHERE {primary_key} = %s"
        sql = sql1 % (primary_key_value,)
        query.update(sql,session)
        return jsonify({'message': 'Data deleted successfully!'}),200
    except Exception as e:
        return jsonify({"message":str(e)}),400

@app.route('/api/add_data',methods=['POST'])
def add_data():
    tableNames = query.get_visibleTables(session)
    try:
        data = request.json
        table = tableNames.get(data.get('table'))[1]
        insert_data = data.get('data')

        insert_datas = [insert_data]

        if not all([table, insert_datas]):
            return jsonify({"message": "Missing required fields"}), 400

        for real_data in insert_datas:
            if table != "interviewscore":
                real_data = query.view_to_table(table,real_data,session)

            # 如果值为空，则没有列
            columns = ", ".join([key for key, value in real_data.items() if value])
            # 判断是否为纯数字列
            # 还要判断是否为空，为空的话则没有对应的columns
            placeholders = ", ".join([query.value_change(value) for value in real_data.values() if value])
            sql = f"INSERT INTO {table} ({columns}) VALUES ({placeholders})"
            tprint(sql)
            query.update(sql,session)
        return jsonify({'message': 'Data added successfully!'}),200
    except Exception as e:
        return jsonify({"message":str(e)}),400

@app.route('/api/get_tables',methods=['GET'])
def get_tables():
    # 这里是下拉框的表格名字，可以改成nickname
    tableNames = query.get_visibleTables(session)
    return jsonify(tableNames)

@app.route('/api/get_views',methods=['GET'])
def get_views():
    viewsNames = config.viewNames
    return jsonify(viewsNames)

@app.route("/api/forbbiden_columns",methods=["POST"])
def forbbiden_columns():
    # 这里的table是可视的table
    tableNames = query.get_visibleTables(session)
    data = request.json
    table = tableNames.get(data.get('table'))[1]
    if table in config.forbidden_keys.keys():
        return jsonify(config.forbidden_keys[table])
    else:
        return jsonify([])

# 获取该段落是否有下拉框
@app.route("/api/get_dropdown",methods=["POST"])
def get_dropdown():
    tableNames = query.get_visibleTables(session)
    data = request.json
    table = tableNames.get(data.get('table'))[1]
    column = data.get('column')
    # 先判断是否有该表的配置
    if table in config.dropdown and column in config.dropdown[table]:
        # 判断是什么类型的配置
        ty = config.dropdown[table][column][0]
        content = config.dropdown[table][column][1]
        if ty == "enum":
            result = {"ty":"dropdown","content":content}
        else:
            # 否则的话就需要去查询
            sql = f"SELECT {column} FROM {content['table']}"
            result1 = [value[column] for value in query.query(sql,session)]
            result = {"ty":"dropdown","content":result1}
    else:
        result = {"ty":"input"}
    return jsonify(result)

# 获取当前是否是可以编辑的表格
@app.route("/api/is_editable",methods=["POST"])
def is_editable():
    # 这里idtable是可操作的table
    data = request.json
    table = data.get('table')
    tableNames = query.get_editableTables(session)
    if table in tableNames:
        # 代表可以编辑
        return jsonify({"isEditable":True})
    else:
        return jsonify({"isEditable":False})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001, debug=False)