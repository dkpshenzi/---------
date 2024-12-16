import pymysql
from config import outkey,DEBUG
from config import worker_config,admin_config
from config import e_admin_tableNames,e_worker_tableNames
from config import v_admin_tableNames,v_worker_tableNames

class SQLerror:
    def __init__(self, message):
        self.message = message
    def __str__(self):
        return self.message

# 查询的代码
def query(sql,session=None):
    db_config = get_config(session)
    db = pymysql.connect(host=db_config['MYSQL_HOST'],
                         user=db_config['MYSQL_USER'],
                         password=db_config['MYSQL_PASSWORD'],
                         database=db_config['MYSQL_DB'],
                         charset='utf8',
                         cursorclass=pymysql.cursors.DictCursor)
    cur = db.cursor()
    result = None
    try:
        cur.execute(sql)
        result = cur.fetchall()
        db.commit()
    except:
        db.rollback()
        print("查询失败")
        print(sql)
        raise SQLerror("查询执行失败")
    cur.close()
    db.close()
    return result

# 更新和插入的代码
def update(sql,session=None):
    db_config = get_config(session)
    # 可以进行更新和插入操作
    db = pymysql.connect(host=db_config['MYSQL_HOST'],
                         user=db_config['MYSQL_USER'],
                         password=db_config['MYSQL_PASSWORD'],
                         database=db_config['MYSQL_DB'],
                         charset='utf8',
                         cursorclass=pymysql.cursors.DictCursor)
    cur = db.cursor()
    result = "Success"
    try:
        cur.execute(sql)
        db.commit()
    except:
        db.rollback()
        print("更新失败")
        print(sql)
        raise SQLerror("更新执行失败")
    cur.close()
    db.close()
    return result

# 是否是管理员
def isAdmin(account):
    sql = f"SELECT Role FROM user WHERE Account='{account}'"
    result = query(sql)[0]
    if result['Role'] == 'Admin':
        tprint("管理员查询")
    return result['Role'] == 'Admin'

# 返回对应的查询配置
def get_config(session=None):
    if session:
        return admin_config if isAdmin(session['username']) else worker_config
    else:
        return admin_config

# 返回对应可以查看的基础表名
def get_visibleTables(session=None):
    if session:
        return v_admin_tableNames if isAdmin(session['username']) else v_worker_tableNames
    else:
        return v_admin_tableNames
def get_editableTables(session=None):
    if session:
        return e_admin_tableNames if isAdmin(session['username']) else e_worker_tableNames
    else:
        return e_admin_tableNames

# 给字符串数据加上单引号
def value_change(value):
    return value if value.isnumeric() else repr(value)

# 将带外键的Name转换成实际的表数据Id：
def view_to_table(table,data,session=None):
    if table in outkey.keys():
        # 这里要分表格
        replace_columns = outkey[table]
        # 在拷贝表中循环
        data_copy = data.copy()
        # 不仅要把列名改成对应的键，还要将值改成对应的值
        for key, value in data_copy.items():
            if key in replace_columns:
                # 要将键名更改为对应的键，并且删除原来的键
                del data[key]
                # 将值改成对应的值
                c_table = replace_columns[key]['table']
                c_column = replace_columns[key]['column']
                # 如果是字符的要加上单引号
                value = value_change(value)
                sql = f"SELECT {c_column} FROM `{c_table}` WHERE {c_table}.{key}={value}"
                result = query(sql,session)[0][c_column]
                data[c_column] = str(result)
    return data

def tprint(value):
    if DEBUG:
        print(value)