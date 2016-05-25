#coding:utf-8

from	django.db	import	connections, transaction
from	kis.lib.userdata	import	CheckAccess
import	psycopg2



def	GetChoiceDriverList():
    cursor = connections['kis'].cursor()
    cursor.execute("SELECT user_kod||'#'||name1||' '||name2||' '||name3,name1||' '||name2||' '||name3 AS fio FROM t_show_user_list WHERE head_flag='0';")
    data = cursor.fetchall()

    return data



### --- Добавление водителя ---
def	AddADriver(user_kod,driver_kod,location,driver_name,license,category):
    user_kod = user_kod.encode("utf-8")
    driver_kod = driver_kod.encode("utf-8")
    location = location.encode("utf-8")
    driver_name = driver_name.encode("utf-8")
    license = license.encode("utf-8")
    category = category.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddADriver('%s','%s','%s','%s','%s','%s');" % (user_kod,driver_kod,location,driver_name,license,category))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Список водителей ---
def	GetDriverList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_drivers;")
    data = cursor.fetchall()

    return data



### --- Удаление водителя ---
def	DelADriver(driver_kod):
    driver_kod = driver_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_auto_drivers SET t_rec_delete=1 WHERE t_rec_id='%s';" % (driver_kod))
    transaction.commit_unless_managed()



### --- Список типов автомобилей ---
def	GetAutoTypeList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_type_list;")
    data = cursor.fetchall()

    return data



### --- Виды топлива автомобилей ---
def	GetAutoFuelList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_fuel_type;")
    data = cursor.fetchall()

    return data



### --- Добавление автомобиля ---
def	AddAAuto(user_kod,location,mark,auto_type,g_number,status,fuel_type,fuel_s,fuel_w):
    user_kod = user_kod.encode("utf-8")
    location = location.encode("utf-8")
    mark = mark.encode("utf-8")
    auto_type = auto_type.encode("utf-8")
    g_number = g_number.encode("utf-8")
    status = status.encode("utf-8")
    fuel_type = fuel_type.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddAAuto('%s','%s','%s',%s,'%s',%s,%s,%s,%s);" % (user_kod,location,mark,auto_type,g_number,status,fuel_type,fuel_s,fuel_w))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Список автомобилей ---
def	GetAutoList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_at_list WHERE at_status_kod='0' OR at_status_kod='1';")
    data = cursor.fetchall()

    return data



### --- Получение данных записи списка автомобилей ---
def	GetAutoData(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_at_list WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data



### --- Редактирование автомобиля ---
def	EditAAuto(rec_id,location,mark,auto_type,g_number,status,fuel_type,fuel_s,fuel_w,user_kod):
    rec_id = rec_id.encode("utf-8")
    location = location.encode("utf-8")
    mark = mark.encode("utf-8")
    auto_type = auto_type.encode("utf-8")
    g_number = g_number.encode("utf-8")
    status = status.encode("utf-8")
    fuel_type = fuel_type.encode("utf-8")
    user_kod = user_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditAAuto(%s,'%s','%s',%s,'%s',%s,%s,%s,%s,'%s');" % (rec_id,location,mark,auto_type,g_number,status,fuel_type,fuel_s,fuel_w,user_kod))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Список автомобилей для оформления заказа---
def	GetAutoTaskList(option='full'):
    cursor = connections['default'].cursor()
    if option == 'shot':
	cursor.execute("SELECT rec_id,location||' '||mark||' '||auto_type||' '||status_name AS mark FROM t_show_auto_at_list WHERE at_status_kod='3';")
    elif option == 'middle':
	cursor.execute("SELECT rec_id,location||' '||mark||' '||auto_type||' '||status_name AS mark FROM t_show_auto_at_list WHERE at_status_kod='0' OR at_status_kod='2';")
    else:
	cursor.execute("SELECT rec_id,location||' '||mark||' '||auto_type||' '||status_name AS mark FROM t_show_auto_at_list WHERE at_status_kod='0' OR at_status_kod='2' OR at_status_kod='3';")
    data = cursor.fetchall()

    return data



#### --- Добавление групповой рассылки email адреса ---
def	AddGroupEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT count(*) FROM t_auto_group_mail WHERE t_email=btrim('%s') AND t_author_address=0;" % (email))
    data = cursor.fetchone()
    if data[0] == 0:
	cursor = connections['default'].cursor()
	cursor.execute("INSERT INTO t_auto_group_mail (t_email) VALUES(btrim('%s'));" % (email))
	transaction.commit_unless_managed()



#### --- Получение списка адресов группы рассылки ---
def	GetGroupEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email,t_rec_id FROM t_auto_group_mail WHERE t_author_address=0;")
    data = cursor.fetchall()
    
    return data


#### --- Удаление группового адреса рассылки ---
def	DelGroupEmail(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM  t_auto_group_mail WHERE t_rec_id=%s;" % (rec_id))
    transaction.commit_unless_managed()



#### --- Получение обратного eamil адреса ---
def	GetAuthorEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_auto_group_mail WHERE t_author_address=1;")
    data = cursor.fetchone()
    
    return data[0]


#### --- Сохранение обратного eamil адреса ---
def	SaveAuthorEmail(email):
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_auto_group_mail SET t_email=btrim('%s') WHERE t_author_address=1;" % (email))
    transaction.commit_unless_managed()
    

#### --- Добавление начала сезона ---
def	NewDateSeason(start_date,season):
    season = season.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("INSERT INTO t_auto_season(t_start_date,t_s_w) VALUES('%s','%s');" % (start_date,season))
    transaction.commit_unless_managed()


#### --- Получение списка начал летнего и зимнего периодов ---
def	GetSeasonSW(season):
    season = season.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT btrim(to_char(t_rec_id,'99999')),to_char(t_start_date,'DD.MM.YYYY') FROM t_auto_season WHERE t_s_w='%s' ORDER BY t_start_date;" % (season))
    data = cursor.fetchall()
    
    return data


#### --- Удаление начала летнего или зимнего периода ---
def	DelSeasonSW(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM  t_auto_season WHERE t_rec_id=%s;" % (rec_id))
    transaction.commit_unless_managed()



#### --- Получение списка расхода топлива для автомобиля с прицепом ---
def	GetTrailerSW(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT count(*) FROM t_show_auto_trailer WHERE auto_kod='%s';" % (rec_id))
    data = cursor.fetchone()
    if data[0] == 1:
	cursor.execute("SELECT fuel_s,fuel_w FROM t_show_auto_trailer WHERE auto_kod='%s';" % (rec_id))
	data = cursor.fetchone()
    else:
	data = ('0.00','0.00')

    return data




#### --- Установка расхода топлива с прицепом ---
def	SetTrailerSW(car_id,fuel_s,fuel_w):
    car_id = car_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_SetATrailerSW(%s,%s,%s);" % (car_id,fuel_s,fuel_w))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data






#### --- Получение списка водителей для заполнения формы ---
def	GetDriverChoiceList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT rec_id,fio_driver||' '||location FROM t_show_auto_drivers;")
    data = cursor.fetchall()

    return data


### --- Получение списка руководителей ЦФО ---
def	GetChiefCFOList():    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT ruk_kod,name1||' '||name2||' '||name3 FROM t_show_auto_ruk_cfo;")
    data = cursor.fetchall()

    return data


### --- Создание планового выезда ---
def	AddAPlanTrip(user_id,datetime,datetime_end,route,place,driver_kod,auto_kod,target,traveler,trailer,chief_kod):
    user_id = user_id.encode("utf-8")
    datetime = datetime.encode("utf-8")
    datetime_end = datetime_end.encode("utf-8")
    route = route.encode("utf-8")
    place = place.encode("utf-8")
    driver_kod = driver_kod.encode("utf-8")
    auto_kod = auto_kod.encode("utf-8")
    target = target.encode("utf-8")
    traveler = traveler.encode("utf-8")
    trailer = trailer.encode("utf-8")
    chief_kod = chief_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddAPlanTrip('%s','%s','%s','%s','%s','%s',%s,'%s','%s','%s','%s');" % (user_id,datetime,datetime_end,route,place,driver_kod,auto_kod,target,traveler,trailer,chief_kod))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение списка плановых выездов ---
def	GetAPlanTripList(search):    
    search = search.encode("utf-8").replace(' ','')
    cursor = connections['default'].cursor()
    if search == '':
	cursor.execute("SELECT * FROM t_show_auto_trip WHERE plan_or_task='plan';")
    else:
	cursor.execute("""SELECT * FROM t_show_auto_trip WHERE plan_or_task='plan' AND \
	(\
	to_tsvector('russian',trip_date) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',trip_time) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',duration) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',route) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',object) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_location) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_mark) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',fio_driver) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name2) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',status_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',chief_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',chief_name2) @@ to_tsquery('russian','%s') \
	);""" % (search,search,search,search,search,search,search,search,search,search,search,search,search))
    data = cursor.fetchall()

    return data



### --- Получение списка статусов в зависимости от кода заказа ---
def	GetAStatusChoiceList(status_kod):    
    status_kod = status_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT status_kod,status_name FROM t_show_auto_status_choice WHERE status_auto='%s';" % (status_kod))
    data = cursor.fetchall()

    return data



### --- Получение списка всех возможных статусов ---
def	GetAStatusAllList():    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT DISTINCT status_kod,status_name FROM t_show_auto_status_choice;")
    data = cursor.fetchall()

    return data



### --- Получение данных одного выезда ---
def	GetATripData(rec_id):    
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_trip WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data


### --- Редактирование планового выезда ---
def	EditAPlanTrip(rec_id,user_id,datetime,datetime_end,duration,route,place,driver_kod,auto_kod,target,traveler,trailer,chief_kod,speedo1,speedo2,fuel,status,comment):
    rec_id = rec_id.encode("utf-8")
    user_id = user_id.encode("utf-8")
    datetime = datetime.encode("utf-8")
    datetime_end = datetime_end.encode("utf-8")
    route = route.encode("utf-8")
    place = place.encode("utf-8")
    driver_kod = driver_kod.encode("utf-8")
    auto_kod = auto_kod.encode("utf-8")
    target = target.encode("utf-8")
    traveler = traveler.encode("utf-8")
    trailer = trailer.encode("utf-8")
    chief_kod = chief_kod.encode("utf-8")
    status = status.encode("utf-8")
    comment = comment.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditAPlanTrip(%s,'%s','%s','%s',%s,'%s','%s','%s',%s,'%s','%s','%s','%s',%s,%s,%s,%s,'%s');" % (rec_id,user_id,datetime,datetime_end,duration,route,place,driver_kod,auto_kod,target,traveler,trailer,chief_kod,speedo1,speedo2,fuel,status,comment))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]




### --- Получение истории статусов ---
def	GetAStatusHistory(trip_kod):    
    trip_kod = trip_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_status WHERE trip_kod='%s';" % (trip_kod))
    data = cursor.fetchall()

    return data



### --- Создание нового заказа на выезд ---
def	AddATaskTrip(user_id,datetime,datetime_end,route,place,auto_kod,target):
    user_id = user_id.encode("utf-8")
    datetime = datetime.encode("utf-8")
    datetime_end = datetime_end.encode("utf-8")
    route = route.encode("utf-8")
    place = place.encode("utf-8")
    auto_kod = auto_kod.encode("utf-8")
    target = target.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddATaskTrip('%s','%s','%s','%s','%s',%s,'%s');" % (user_id,datetime,datetime_end,route,place,auto_kod,target))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение новых заказов на выезд ---
def	GetANewTaskTrip(search):
    search = search.encode("utf-8").replace(' ','')
    cursor = connections['default'].cursor()
    if search == '':
	cursor.execute("SELECT * FROM t_show_auto_trip_newtask;")
    else:
	cursor.execute("""SELECT * FROM t_show_auto_trip_newtask \
	WHERE \
	to_tsvector('russian',trip_date) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',trip_time) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',duration) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',route) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',object) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_location) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_mark) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_type_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',status_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name2) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_phone) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',chief) @@ to_tsquery('russian','%s') \
	;""" % (search,search,search,search,search,search,search,search,search,search,search,search,search))
	

    data = cursor.fetchall()

    return data



### --- Получение записи нового заказа на выезд ---
def	GetANewTaskTripData(rec_id):    
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_trip_newtask WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data



### --- Редактирование заявки на выезд пользователем ---
def	EditATaskTrip(rec_id,user_id,datetime,datetime_end,route,place,auto_kod,target,status,comment):
    rec_id = rec_id.encode("utf-8")
    user_id = user_id.encode("utf-8")
    datetime = datetime.encode("utf-8")
    datetime_end = datetime_end.encode("utf-8")
    route = route.encode("utf-8")
    place = place.encode("utf-8")
    auto_kod = auto_kod.encode("utf-8")
    target = target.encode("utf-8")
    status = status.encode("utf-8")
    comment = comment.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditATaskTrip(%s,'%s','%s','%s','%s','%s',%s,'%s',%s,'%s');" % (rec_id,user_id,datetime,datetime_end,route,place,auto_kod,target,status,comment))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение запиcей руковдителей ЦФО для запроса подписи ---
def	GetCFORukEmailList():    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT email,name1||' '||name2||' '||name3 FROM t_show_auto_ruk_cfo")
    data = cursor.fetchall()

    return data



#### --- Получение обратного eamil адреса ---
def	GetAuthorEmail():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_email FROM t_auto_group_mail WHERE t_author_address=1;")
    data = cursor.fetchone()
    
    return data[0]


### --- Фиксируем email адрес руководителя заказе ---
def	WriteEmailRuk(trip_kod,email):
    trip_kod = trip_kod.encode("utf-8")
    email = email.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_auto_trip SET t_chief_email='%s' WHERE t_rec_id=%s;" % (email,trip_kod))
    transaction.commit_unless_managed()



### --- Регистрация истории отправки email уведомлений ---
def	EmailHistory(trip_kod,email,subject):
    trip_kod = trip_kod.encode("utf-8")
    email = email.encode("utf-8")
    subject = subject.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("INSERT INTO t_auto_email_history(t_trip_kod,t_email,t_subject) VALUES(%s,'%s','%s');" % (trip_kod,email,subject))
    transaction.commit_unless_managed()



#### --- Получение истории email рассылки ---
def	GetHistoryEmail(trip_kod):
    trip_kod = trip_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_email_history WHERE trip_kod='%s';" % (trip_kod))
    data = cursor.fetchall()
    
    return data




### --- Получение выездов по заказам  ---
def	GetATaskTrip(search):
    search = search.encode("utf-8").replace(' ','')
    cursor = connections['default'].cursor()
    if len(search) == 0:
	cursor.execute("SELECT * FROM t_show_auto_tasktrip WHERE plan_or_task='task' AND status_kod!='0';")
    else:
	cursor.execute("""SELECT * FROM t_show_auto_tasktrip \
	WHERE plan_or_task='task' AND status_kod!='0' AND (\
	to_tsvector('russian',trip_date) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',trip_time) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',duration) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',route) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',object) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_location) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_mark) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',auto_type_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',driver_fio) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',status_name) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_name2) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',author_phone) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',chief_name1) @@ to_tsquery('russian','%s') OR \
	to_tsvector('russian',chief_name2) @@ to_tsquery('russian','%s')) \
	;""" % (search,search,search,search,search,search,search,search,search,search,search,search,search,search,search))
	

    data = cursor.fetchall()

    return data



6### --- Получение получение данных одного выезда по заказу ---
def	GetATripTaskData(rec_id):    
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_tasktrip WHERE rec_id='%s';" % (rec_id))
    data = cursor.fetchone()

    return data




### --- Редактирование заявки на выезд административной группой ---
def	EditATaskTrip2(rec_id,user_id,datetime,datetime_end,duration,route,place,auto_kod,target,traveler,trailer,driver,speedo1,speedo2,fuel,status,comment):
    rec_id = rec_id.encode("utf-8")
    user_id = user_id.encode("utf-8")
    datetime = datetime.encode("utf-8")
    datetime_end = datetime_end.encode("utf-8")
    route = route.encode("utf-8")
    place = place.encode("utf-8")
    auto_kod = auto_kod.encode("utf-8")
    target = target.encode("utf-8")
    traveler = traveler.encode("utf-8")
    trailer = trailer.encode("utf-8")
    driver = driver.encode("utf-8")
    status = status.encode("utf-8")
    comment = comment.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditATaskTrip2(%s,'%s','%s','%s',%s,'%s','%s',%s,'%s','%s','%s','%s',%s,%s,%s,%s,'%s');" % (rec_id,user_id,datetime,datetime_end,duration,route,place,auto_kod,target,traveler,trailer,driver,speedo1,speedo2,fuel,status,comment))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



#### --- Получение данных для отчета 0 ---
def	GetReport0(start_date,end_date):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_report0 WHERE date>='%s' AND date<='%s';" % (start_date,end_date))
    data = cursor.fetchall()
    
    return data



#### --- Получение данных для отчета 0 ---
def	GetReport0sum(start_date,end_date):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT driver,sum(duration) FROM t_show_auto_report0 WHERE date>='%s' AND date<='%s' GROUP BY driver ORDER BY driver;" % (start_date,end_date))
    data = cursor.fetchall()
    
    return data



#### --- Получение данных для установки статуса авто  ---
def	GetAuStatusList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_at_status_list WHERE rec_id='0' OR rec_id='1';")
    data = cursor.fetchall()
    
    return data



#### --- Получение данных для установки статуса авто  ---
def	GetAuStatusHistory(car_kod):
    car_kod = car_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_at_status WHERE at_kod='%s';" % (car_kod))
    data = cursor.fetchall()

    return data



### --- Список личных автомобилей ---
def	GetPersonAutoList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_at_list WHERE at_status_kod='2';")
    data = cursor.fetchall()

    return data



### --- Добавление личного автомобиля ---
def	AddAAutoPerson(user_kod,location,mark,auto_type,g_number):
    user_kod = user_kod.encode("utf-8")
    location = location.encode("utf-8")
    mark = mark.encode("utf-8")
    auto_type = auto_type.encode("utf-8")
    g_number = g_number.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddAAutoPerson('%s','%s','%s',%s,'%s');" % (user_kod,location,mark,auto_type,g_number))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Редактирование личного автомобиля ---
def	EditAAutoPerson(rec_id,location,mark,auto_type,g_number):
    rec_id = rec_id.encode("utf-8")
    location = location.encode("utf-8")
    mark = mark.encode("utf-8")
    auto_type = auto_type.encode("utf-8")
    g_number = g_number.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditAAutoPerson(%s,'%s','%s',%s,'%s');" % (rec_id,location,mark,auto_type,g_number))
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Загрузка инструкции ---
def	LoadGuide(user_kod,guide,file_name,file_ext,data):
    user_kod = user_kod.encode("utf-8")
    guide = guide.encode("utf-8")
    file_name = file_name.encode("utf-8")
    file_ext = file_ext.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("INSERT INTO t_auto_docs(t_guide,t_ext,t_data,t_file_name,t_create_author) VALUES(%s,%s,%s,%s,%s);", (guide,file_ext,psycopg2.Binary(data),file_name,user_kod),)
    transaction.commit_unless_managed()



### --- Список инструкций ---
def	GetGuideList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_auto_docs;")
    data = cursor.fetchall()

    return data


### --- Получение файла  ---
def	GetDoc(d_kod):
    d_kod = d_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_ext,t_data,t_file_name FROM t_auto_docs WHERE t_rec_id='%s';" % (d_kod))
    data = cursor.fetchone()

    return data



### --- Удаление инструкции ---
def	DeleteGuide(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_auto_docs SET t_rec_delete=1 WHERE t_rec_id=%s;" % (rec_id))
    transaction.commit_unless_managed()


