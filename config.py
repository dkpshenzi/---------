import os

class Config:
    SECRET_KEY = os.environ.get('SECRET_KEY') or 'dkp'

DEBUG = True

worker_config = {
    'MYSQL_HOST':'localhost',
    'MYSQL_USER':'Worker',
    'MYSQL_PASSWORD':'12345678',
    'MYSQL_DB':'2024_database'
}
admin_config = {
    'MYSQL_HOST':'localhost',
    'MYSQL_USER':'Admin',
    'MYSQL_PASSWORD':'12345678',
    'MYSQL_DB':'2024_database'
}

v_worker_tableNames = {
    "writtentestscore_view":["复试笔试打分表","writtentestscore",1],
    "interviewscore_view":["复试面试打分表","interviewscore",2],
    "department":["学院表","department",3],
    "major_view":["专业表","major",4],
    "scoringcriteria":["评分标准表","scoringcriteria",5],
    "student_view":["学生表","student",6],
    "teacher_view":["教师表","teacher",7],
    "batch":["批次表","batch",8],
    "weight":["权重表","weight",9],
}
v_admin_tableNames = {
    "writtentestscore_view":["复试笔试打分表","writtentestscore",1],
    "interviewscore_view":["复试面试打分表","interviewscore",2],
    "department":["学院表","department",3],
    "major_view":["专业表","major",4],
    "scoringcriteria":["评分标准表","scoringcriteria",5],
    "student_view":["学生表","student",6],
    "teacher_view":["教师表","teacher",7],
    "user":["用户表","user",8],
    "batch":["批次表","batch",9],
    "weight":["权重表","weight",10],
}
e_worker_tableNames = [
    "interviewscore_view",
    "writtentestscore_view"
]
e_admin_tableNames = [
    "department",
    "interviewscore_view",
    "major_view",
    "scoringcriteria",
    "student_view",
    "teacher_view",
    "writtentestscore_view",
    "user",
    "batch",
    "weight"
]

outkey = {
    'student':{
        "MajorName" :{
            "table":"major",
            "column":"MajorId"},
        "Batch":{
            "table":"batch",
            "column":"BatchId"
        }
    },
    'interviewscore':{
        "StudentName":{
            "table":"student",
            "column":"StudentId"
        },
        "TeacherName":{
            "table":"teacher",
            "column":"TeacherId"
        },
        "CriteriaName":{
            "table":"scoringcriteria",
            "column":"CriteriaId"
        }
    },
    'major':{
        "DepartmentName":{
            "table":"department",
            "column":"DepartmentId"
        }
    },
    "teacher":{
        "DepartmentName":{
            "table":"department",
            "column":"DepartmentId"
        }
    },
    "writtentestscore":{
        "StudentName":{
            "table":"student",
            "column":"StudentId"
        }
    }
}

forbidden_keys = {
    "interviewscore":["ScoringTime","StudentName","TeacherName","Batch"],
    "scoringcriteria":["CreateTime","UpdateTime"],
    "student":["Stauts"],
    "writtentestscore":["Time","StudentName","Batch"],
    "user":["CreateTime"]
}

dropdown = {
    'student':{
        "Gender":["enum",["男","女"]],
        "MajorName":["outkey",outkey["student"]["MajorName"]],
        "Status":["enum",["已报名","笔试完成","面试完成","已录取","未录取"]],
        "Batch":["outkey",outkey["student"]["Batch"]]
    },
    'interviewscore':{
        "CriteriaName":["outkey",outkey["interviewscore"]["CriteriaName"]],
    },
    "major":{
        "DepartmentName":["outkey",outkey["major"]["DepartmentName"]],
        "IsActive":["enum",[1,0]]
    },
    "teacher":{
        "Gender":["enum",["男","女"]],
        "DepartmentName":["outkey",outkey["teacher"]["DepartmentName"]],
        "Title":["enum",["教授","副教授","讲师","助教"]],
        "IsActive":["enum",[1,0]]
    },
    "user":{
        "Role":["enum",["Admin","Worker"]],
    }
}

viewNames = [
    "专业分数平均表",
    "总分表",
    "专业录取率表",
]