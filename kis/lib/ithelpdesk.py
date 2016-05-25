#coding:utf-8

from	django.db	import	connections, transaction
from	kis.lib.userdata	import	CheckAccess
import	psycopg2
import	os
import	os.path


### --- Список пользователей ---
def	GetItUserList():
    cursor = connections['kis'].cursor()
    cursor.execute("SELECT user_kod,name2||' '||name1 as name FROM t_show_user_list ORDER BY 2;")
    data = cursor.fetchall()

    return data


### --- Добавление пользователя в административную группу ---
def	AddAdminUser(user_kod):
    user_kod = user_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT count(*) FROM t_it_admin_group WHERE t_rec_id='%s';" % (user_kod))
    data = cursor.fetchone()
    if data[0] == 0:
	cursor.execute("INSERT INTO t_it_admin_group (t_rec_id) VALUES('%s');" % (user_kod))
	transaction.commit_unless_managed()



### --- Получение списка административной группы ----
def	GetAdminList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_admin_group;")
    data = cursor.fetchall()
    return data


### --- Удаление пользователя из административной группы ---
def	DelAdminUser(user_kod):
    user_kod = user_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM t_it_admin_group WHERE t_rec_id='%s';" % (user_kod))
    transaction.commit_unless_managed()


### --- Получение обратного адреса ---
def	GetAddressEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_it_email_address;")
    data = cursor.fetchone()
    return data[0]



### --- Сохранение обратного адреса ---
def	EditAddressEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_it_email_address SET t_email='%s';" % (email))
    transaction.commit_unless_managed()



### --- Получение списка заявок ---
def	GetItTaskList(search):    
    search = search.encode("utf-8").replace(' ','')
    cursor = connections['default'].cursor()
    if search == '':
	cursor.execute("SELECT * FROM t_show_it_task;")
    else:
	cursor.execute("""SELECT * FROM t_show_it_task WHERE \
	\
	to_tsvector('russian',serial_n) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',date_str) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',time_str) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',workhour) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',tema) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',task_text) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',isp_name1) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',isp_name2) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',status_name) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',kategory_name) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',user_fio) @@ to_tsquery('russian','%s:*') OR \
	to_tsvector('russian',user_phone) @@ to_tsquery('russian','%s:*') \
	;""" % (search,search,search,search,search,search,search,search,search,search,search,search))
    data = cursor.fetchall()

    return data



### --- Получение данных заявки ---
def	GetItTaskData(task_id):
    task_id = task_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_task WHERE rec_id='%s';" % (task_id))
    data = cursor.fetchone()

    return data



### --- Получение списка исполнителей ----
def	GetIspList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT rec_id as id,name2||' '||name1 as name FROM t_show_it_admin_group;")
    data = cursor.fetchall()
    data.append(['',''])
    return data


### --- Получение списка статусов ----
def	GetStatusList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_status_list;")
    data = cursor.fetchall()
    return data


### --- Получение списка категорий ----
def	GetCategoryList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_category_list;")
    data = cursor.fetchall()
    return data


### --- Получение старого исполнителя ----
def	GetOldIsp(user_kod):
    user_kod = user_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_rec_id AS rec_id,t_user_name2||' 't_user_name1 AS user_name FROM t_user_kis WHERE t_rec_id='%s';" % (user_kod))
    data = cursor.fetchone()
    return data



### --- Установка нового статуса ---
def	NewItTaskStatus(user_kod,rec_id,tema,isp_kod,comment,status_kod,kategory_kod,ip,file_name,file_ext,data,work):
    user_kod = user_kod.encode("utf-8")
    rec_id = rec_id.encode("utf-8")
    tema = tema.encode("utf-8")
    isp_kod = isp_kod.encode("utf-8")
    comment = comment.encode("utf-8")
    status_kod = status_kod.encode("utf-8")
    kategory_kod = kategory_kod.encode("utf-8")
    ip = ip.encode("utf-8")
    file_name = file_name.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_NewStatusItTask(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s);", (user_kod,rec_id,tema,isp_kod,comment,status_kod,kategory_kod,ip,file_name,file_ext,psycopg2.Binary(data),work),)
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]


### --- Вспомогательная функция загрузки файлов в базу ---
def	LoadDataFile():
    cursor = connections['default'].cursor()
    file_name = os.listdir('/home/task/it')
    for item in file_name:
	f = open('/home/task/it/'+item,'rb')
	data = f.read()
	f.close()
	(path,ext) = os.path.splitext(item)
	print item
	cursor.execute("UPDATE t_it_docs SET t_data=%s WHERE t_rec_id=%s;", (psycopg2.Binary(data),path),)
	transaction.commit_unless_managed()
	


### --- Получение истории статусов ---
def	GetItTaskStatusHistory(task_id):
    task_id = task_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_task_work WHERE task_kod='%s';" % (task_id))
    data = cursor.fetchall()

    return data



### --- Получение записи с загруженным файлом ---
def	GetItDocData(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_it_docs WHERE t_task_work_kod='%s';" % (rec_id))
    data = cursor.fetchone()

    return data



### --- Получение комментариев пользователя ---
def	GetItTaskMesUser(task_id):
    task_id = task_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_comment_user WHERE it_task_kod='%s';" % (task_id))
    data = cursor.fetchall()

    return data


### --- Получение записи с загруженным файлом ---
def	GetItDocData2(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_it_docs WHERE t_rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data



### --- Получение списка заявок пользователя ---
def	GetItTaskUser(search,user_kod):    
    user_kod = user_kod.encode("utf-8")
    search = search.encode("utf-8").replace(' ','')
    cursor = connections['default'].cursor()
    if search == '':
	cursor.execute("SELECT * FROM t_show_it_task WHERE user_kod='%s';" % (user_kod))
    else:
	cursor.execute("""SELECT * FROM t_show_it_task WHERE user_kod='%s' AND \
	(\
	to_tsvector('russian',serial_n) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',date_str) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',time_str) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',workhour) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',tema) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',isp_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',isp_name2) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',status_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',kategory_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',user_fio) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',user_phone) @@ to_tsquery('russian','%s')) \
	;""" % (user_kod,search,search,search,search,search,search,search,search,search,search,search))
    data = cursor.fetchall()

    return data



### --- Добавление нового комментария (и загрузки файла) к заявке пользователем ---
def	AddItDocUser(task_id,file_name,user_comment,file_ext,ip,file_data):
    task_id = task_id.encode("utf-8")
    file_name = file_name.encode("utf-8")
    user_comment = user_comment.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    ip = ip.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddItDocUser(%s,%s,%s,%s,%s,%s);", (task_id,file_name,user_comment,file_ext,ip,psycopg2.Binary(file_data)),)
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Создание новой заявки пользователем ---
def	NewItTaskUser(user_kod,task_text,ip):
    user_kod = user_kod.encode("utf-8")
    task_text = task_text.encode("utf-8")
    ip = ip.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_NewItTaskUser('%s','%s','%s');" % (user_kod,task_text,ip))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Создание новой заявки административной группой ---
def	NewItTaskSelf(tema,task,isp_kod,category_kod,working,user_kod,ip):
    user_kod = user_kod.encode("utf-8")
    task = task.encode("utf-8")
    ip = ip.encode("utf-8")
    tema = tema.encode("utf-8")
    isp_kod = isp_kod.encode("utf-8")
    category_kod = category_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_NewItTaskSelf('%s','%s','%s',%s,%s,'%s','%s');" % (tema,task,isp_kod,category_kod,working,user_kod,ip))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



#### --- Получение обратного email адреса ---
def	GetAuthorEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_it_email_address;")
    data = cursor.fetchone()
    
    return data[0]


#### --- Получение истории email рассылки ---
def	GetHistoryEmail(task_kod):
    task_kod = task_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_email_history WHERE task_kod='%s';" % (task_kod))
    data = cursor.fetchall()
    
    return data


#### --- Получение списка адресов группы рассылки ---
def	GetGroupEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT email FROM t_show_it_admin_group;")
    data = cursor.fetchall()
    
    return data


### --- Регистрация истории отправки email уведомлений ---
def	EmailHistory(task_kod,email,subject):
    task_kod = task_kod.encode("utf-8")
    email = email.encode("utf-8")
    subject = subject.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("INSERT INTO t_it_email_history(t_task_kod,t_email,t_subject) VALUES(%s,'%s','%s');" % (task_kod,email,subject))
    transaction.commit_unless_managed()



### --- Получение данных по статусу ---
def	GetItTaskStatusData(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_task_work WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data



### --- Получение данных по сообщению пользователя ---
def	GetItTaskMessData(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_it_comment_user WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data




### --- Получение данных по для отчета ---
def	GetDataReport(start_date,end_date):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_ReportIt('%s','%s') AS (\
		isp_name varchar(100),\
		phone varchar(20),\
		task_all int,\
		work_all int,\
		task_ok int,\
		work_ok int,\
		percent int \
		)\
    " % (start_date,end_date))

    transaction.commit_unless_managed()

    data = cursor.fetchall()

    return data





