#coding:utf-8

from	django.db	import	connections, transaction
from	kis.lib.userdata	import	CheckAccess
import	psycopg2



def	GetStatusList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT btrim(to_char(t_rec_id,'999')) AS rec_id,t_d_status_name FROM t_d_status_list WHERE t_rec_delete=0 AND t_rec_id!=6 ORDER BY 1;")
    data = cursor.fetchall()

    result = [
    ('ACTIVE','Активные'),
    ('ALL','Все'),
    ]

    for row in data:
	result.append(row)

    return result





def	GetDList(search='',status='ACTIVE'):
    
    search = search.encode("utf-8")
    status = status.encode("utf-8")
    
    if status == 'ACTIVE':
	filter_str = " WHERE status_kod!='5' AND status_kod!='7' AND status_kod!='9'"
    elif status == 'ALL':
	filter_str = " "
    else:
	filter_str = " WHERE status_kod='%s'" % status

    cursor = connections['default'].cursor()
    if search == '':
	cursor.execute("SELECT * FROM t_show_d %s;" % (filter_str))
    else:
	cursor.execute("""SELECT * FROM t_show_d \
	WHERE \
	to_tsvector('russian',rec_id) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',tema) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',user_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',user_name2) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',user_phone) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',contragent) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',ruk_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',ruk_name2) @@ to_tsquery('russian','%s') \
	;""" % (search,search,search,search,search,search,search,search))


    data = cursor.fetchall()
    
    return data





def	GetDData(contract_id):
    contract_id = contract_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d WHERE rec_id='%s';" % (contract_id))
    data = cursor.fetchone()

    return data



def	NewD(user_kod,contragent,tema,text):
    user_kod = user_kod.encode("utf-8")
    contragent = contragent.encode("utf-8")
    tema = tema.encode("utf-8")
    text = text.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_NewD(%s,%s,%s,%s);", [user_kod,contragent,tema,text])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



def	EditD(rec_kod,contragent,tema,text):
    rec_kod = rec_kod.encode("utf-8")
    contragent = contragent.encode("utf-8")
    tema = tema.encode("utf-8")
    text = text.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditD(%s,%s,%s,%s);" ,[rec_kod,contragent,tema,text])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



def	AddDDocs(user_kod,rec_id,file_name,comment,file_ext,data):
    user_kod = user_kod.encode("utf-8")
    rec_id = rec_id.encode("utf-8")
    file_name = file_name.encode("utf-8")
    comment = comment.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddDDocs(%s,%s,%s,%s,%s,%s);", (user_kod,rec_id,file_name,comment,file_ext,psycopg2.Binary(data)),)
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]




def	GetDDocsList(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d_docs WHERE d_kod='%s';" % (d_kod))
    data = cursor.fetchall()

    return data



def	DelDDocs(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM t_d_docs WHERE t_rec_id='%s';" % (d_kod))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data


### --- Получение загруженного файла ---
def	GetDDocs(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_ext,t_data,t_file_name FROM t_d_docs WHERE t_rec_id='%s';" % (d_kod))
    data = cursor.fetchone()

    return data


### --- Получение возможных для выбора статусов ---
def	GetDStatusList(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT status_kod,status_name FROM t_show_d_status_list WHERE status_d_kod='%s';" % (d_kod))
    data = cursor.fetchall()

    return data



def	NewDStatus(request,user_kod,d_id,comment,status):

    access_level = CheckAccess(request,'4').encode('utf-8')
    user_kod = user_kod.encode("utf-8")
    d_id = d_id.encode("utf-8")
    comment = comment.encode("utf-8")
    status = status.encode("utf-8")
    cursor = connections['default'].cursor()
    if status == '2' or status == '3':
	cursor.execute("SELECT t_NewDStatusPerson(%s,%s,%s,%s);",[user_kod,d_id,comment,status])
    else:
	cursor.execute("SELECT t_NewDStatus(%s,%s,%s,%s);" , [user_kod,d_id,comment,status])

    if CheckAccess(request,'4') == 'OK' and (status == '4' or status == '8' or status == '9'):
	transaction.commit_unless_managed()
    if status != '4' and status != '8' and status !='9':
	transaction.commit_unless_managed()

    data = cursor.fetchone()

    return data[0]




### --- Получение истории статусов ---
def	GetDStatus(d_kod):

    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d_status WHERE d_kod='%s';" % (d_kod))
    data = cursor.fetchall()

    return data



#### --- Все возможные статусы ---
def	GetStatusListAll():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT btrim(to_char(t_rec_id,'999')) AS rec_id,t_d_status_name FROM t_d_status_list WHERE t_rec_delete=0 ORDER BY 1;")
    data = cursor.fetchall()

    return data



### --- Загрузка версии договора ---
def	LoadDVer(request,user_kod,rec_id,file_name,file_ext,data):
    user_kod = user_kod.encode("utf-8")
    rec_id = rec_id.encode("utf-8")
    file_name = file_name.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_LoadDocs(%s,%s,%s,%s,%s);", (user_kod,rec_id,file_name,file_ext,psycopg2.Binary(data)),)
    ### --- Проверка доступа ---
    if CheckAccess(request,'4') == 'OK':
	transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Загрузка приложения ---
def	LoadDApp(request,user_kod,rec_id,file_name,file_ext,data):
    user_kod = user_kod.encode("utf-8")
    rec_id = rec_id.encode("utf-8")
    file_name = file_name.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_LoadApp(%s,%s,%s,%s,%s);", (user_kod,rec_id,file_name,file_ext,psycopg2.Binary(data)),)
    ### --- Проверка доступа ---
    if CheckAccess(request,'4') == 'OK':
	transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение файла загруженной версии договора ---
def	GetDVer(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_ext,t_doc_data,t_file_name FROM t_d WHERE t_rec_id='%s';" % (d_kod))
    data = cursor.fetchone()

    return data




### --- Получение файла загруженного приложения ---
def	GetDApp(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_app_ext,t_app_data,t_app_filename FROM t_d WHERE t_rec_id='%s';" % (d_kod))
    data = cursor.fetchone()

    return data



### --- Получение файла загруженного приложения ---
def	CheckDAccess(user_kod,d_kod):
    user_kod = user_kod.encode("utf-8")
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AccessDocs('%s',%s);" % (user_kod,d_kod))
    data = cursor.fetchone()

    return data[0]



### --- Список согласующих ---
def	GetDPerson(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d_person WHERE d_kod='%s';" % (d_kod))
    data = cursor.fetchall()

    return data


### --- Список выбора согласующих ---
def	GetDPersonList():
    cursor = connections['kis'].cursor()
    cursor.execute("SELECT user_kod,name2||' '||name1 as name FROM t_show_user_list ORDER BY 2;")
    data = cursor.fetchall()

    return data



### --- Добавление согласующего ---
def	AddDPerson(request,user_kod,d_id,person_kod):
    user_kod = user_kod.encode("utf-8")
    d_id = d_id.encode("utf-8")
    person_kod = person_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddDPerson('%s',%s,'%s');" % (user_kod,d_id,person_kod))
    ### --- Проверка доступа ---
    if CheckAccess(request,'4') == 'OK':
	transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]




### --- Следующий согласующий ---
def	GetDPersonNext(d_kod):
    data = ['','']
    d_kod = d_kod.encode("utf-8")
    try:
	cursor = connections['default'].cursor()
	cursor.execute("SELECT name2,name1 FROM t_show_d_person_next WHERE d_kod='%s';" % (d_kod))
	data = cursor.fetchone()
    except:
	pass

    return data



### --- Удаление согласующего ---
def	DelDPerson(request,user_kod,rec_kod):
    user_kod = user_kod.encode("utf-8")
    rec_kod = rec_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_DelDPerson('%s','%s');" % (user_kod,rec_kod))
    ### --- Проверка доступа ---
    if CheckAccess(request,'4') == 'OK':
	transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Список email руководителей ---
def	GetEmailRukList():
    cursor = connections['kis'].cursor()
    cursor.execute("SELECT * FROM t_show_ruk_email;")
    data = cursor.fetchall()

    return data


### --- Фиксируем email адрес руководителя в заявке ---
def	WriteEmailRuk(d_kod,email):
    d_kod = d_kod.encode("utf-8")
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_d SET t_email_ruk='%s' WHERE t_rec_id=%s;" % (email,d_kod))
    transaction.commit_unless_managed()


### --- Регистрация истории отправки email уведомлений ---
def	EmailHistory(d_kod,email,subject):
    d_kod = d_kod.encode("utf-8")
    email = email.encode("utf-8")
    subject = subject.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("INSERT INTO t_d_email_history(t_d_kod,t_email,t_subject) VALUES(%s,'%s','%s');" % (d_kod,email,subject))
    transaction.commit_unless_managed()


### --- Получение истории отправки email уведомлений ---
def	GetEmailHistory(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d_email_history WHERE d_kod='%s';" % (d_kod))
    data = cursor.fetchall()

    return data


#### --- Определение фио и должности согласователей ---
def	FIO_Job_Person(rec_id):
    person = []
    for item in rec_id:
	
	item = item.encode("utf-8")
	cursor = connections['kis'].cursor()
	cursor.execute("SELECT u.t_user_job,u.name1||' '||u.name2||' '||u.name3 FROM t_show_user_list u WHERE u.user_kod='%s';" % (item))
	result = cursor.fetchone()
	person.append(result)
    
    return person



#### --- Получение обратного eamil адреса ---
def	GetAuthorEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_d_group_mail WHERE t_author_address=1;")
    data = cursor.fetchone()
    
    return data[0]


#### --- Сохранение обратного eamil адреса ---
def	SaveAuthorEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_d_group_mail SET t_email=btrim('%s') WHERE t_author_address=1;" % (email))
    transaction.commit_unless_managed()
    

#### --- Добавление групповой рассылки email адреса ---
def	AddGroupEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT count(*) FROM t_d_group_mail WHERE t_email=btrim('%s');" % (email))
    data = cursor.fetchone()
    if data[0] == 0:
	cursor = connections['default'].cursor()
	cursor.execute("INSERT INTO t_d_group_mail (t_email) VALUES(btrim('%s'));" % (email))
	transaction.commit_unless_managed()



#### --- Получение списка адресов группы рассылки ---
def	GetGroupEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_d_group_mail WHERE t_author_address=0;")
    data = cursor.fetchall()
    
    return data


#### --- Удаление группового адреса рассылки ---
def	DelGroupEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM  t_d_group_mail WHERE t_email=btrim('%s');" % (email))
    transaction.commit_unless_managed()



### --- Получение email следующего согласующего ---
def	GetDPersonNextEmail(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT person_kod,email,send_email FROM t_show_d_person_next WHERE d_kod='%s';" % (d_kod))
    data = cursor.fetchone()

    return data




#### --- Отметка, что email согласующиму отправлен ---
def	PersonEmailOk(d_id,person_id):
    d_id = d_id.encode("utf-8")
    person_id = person_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_d_person_next SET t_send_email='YES' WHERE t_d_kod=%s AND t_user_kod='%s';" % (d_id,person_id))
    transaction.commit_unless_managed()



#### --- Выборка заявок/согласующих с просрочной дней ---
def	PersonLagDays(days):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_d_person_next WHERE lag_day=%s;" % (days))
    data = cursor.fetchall()

    return data
