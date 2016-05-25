#coding:utf-8
from	django.db	import	connections, transaction
import	re
import	csv


### --- Вспомогательная функция загрузки номенклатуры ЕИСУП в базу ---
def	LoadDataEISUP():

    cursor = connections['default'].cursor()


    #c = re.compile('^\d{9}')

    with open('/home/task/kttk.csv','rb') as csvfile:
	spamreader = csv.reader(csvfile, delimiter='\t', quotechar='\'')
	for row in spamreader:

	    kod = row[0].replace('\"','')
	    name = row[1].decode('cp1251').encode('utf-8')
	    status = row[3].decode('cp1251').encode('utf-8')
	    typename = row[4].decode('cp1251').encode('utf-8').replace('\"','').replace(';','')

	    if status == 'Использование':
		
		print kod, name,typename
		cursor.execute("SELECT t_LoadEisupKod(%s,%s,%s)",[kod,name,typename])
		transaction.commit_unless_managed()



### --- Получение списка ---
def	GetList(search):    

    ### --- Предварительно обрабатываем строку поиска ---
    search = search.encode("utf-8")
    words = search.split()

    n = len(words)

    cursor = connections['default'].cursor()
    if n == 0:
	return []
    elif n == 1:
	cursor.execute("""SELECT * FROM t_show_store_eisup_list WHERE \
	\
	to_tsvector('russian',rec_id) @@ to_tsquery('russian',%s) OR \
	to_tsvector('russian',name) @@ to_tsquery('russian',%s) \
	;""" , [search,search])
    else:
	search = ' & '.join(words)
	cursor.execute("""SELECT * FROM t_show_store_eisup_list WHERE \
	to_tsvector('russian',name) @@ to_tsquery('russian',%s) \
	;""" , [search])
    data = cursor.fetchall()

    return data




### --- Создание нового склада ---
def	AddStoreName(user_kod,name):
    user_kod = user_kod.encode("utf-8")
    name = name.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddStoreName(%s,%s)",[user_kod,name])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение списка складов ---
def	GetStoreList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_list;")
    data = cursor.fetchall()

    return data



### --- Получение названия склада ---
def	GetStoreName(rec_id):
    rec_id = rec_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_list WHERE rec_id=%s;", [rec_id])
    data = cursor.fetchone()

    return data



### --- Редактирование склада ---
def	EditStoreName(store_id,user_kod,name):
    store_id = store_id.encode("utf-8")
    user_kod = user_kod.encode("utf-8")
    name = name.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_EditStoreName(%s,%s,%s)",[store_id,user_kod,name])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Список пользователей ---
def	GetPersonList():
    cursor = connections['kis'].cursor()
    cursor.execute("SELECT user_kod,name2||' '||name1 as name FROM t_show_user_list ORDER BY 2;")
    data = cursor.fetchall()

    return data


### --- Получение списка складов для формы создания кладовщика ---
def	GetStoreListForm():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT rec_id,store_name FROM t_show_store_list;")
    data = cursor.fetchall()

    return data


### --- Создание кладовщика ---
def	AddStorePerson(user_kod,store_kod,author):
    user_kod = user_kod.encode("utf-8")
    store_kod = store_kod.encode("utf-8")
    author = author.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_AddStorePerson(%s,%s,%s)",[user_kod,store_kod,author])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Получение списка кладовщиков ---
def	GetStorePerson():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_person;")
    data = cursor.fetchall()

    return data


### --- Удаление кладовщика ---
def	DelStorePerson(delete_id):
    delete_id = delete_id.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM t_store_person WHERE t_rec_id=%s",[delete_id])
    transaction.commit_unless_managed()



### --- Получение данных по единице номенклатуры ---
def	GetOneData(kod):
    kod = kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_eisup_list WHERE rec_id=%s;" , [kod,])
    data = cursor.fetchone()

    return data



### --- Получение справочника модели данных ---
def	GetModelDataList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_model_data_list;")
    data = cursor.fetchall()

    return data



### --- Установка модели данных ---
def	SaveModelData(one,modeldata):
    one = one.encode("utf-8")
    modeldata = modeldata.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("UPDATE t_store_eisup_list SET t_model_kod=%s WHERE t_rec_id=%s",[modeldata,one])
    transaction.commit_unless_managed()



### --- Список складов, доступных данному пользователю ---
def	GetStoreListUser(user_kod):
    user_kod = user_kod.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT store_kod,store_name FROM t_show_store_person WHERE person_kod=%s;",[user_kod,])
    data = cursor.fetchall()

    return data


### --- Справочник Единиц измерений ---
def	GetOkeiList():
    cursor = connections['default'].cursor()
    cursor.execute("SELECT rec_id,okei_name FROM t_show_tmc_okei;")
    data = cursor.fetchall()

    return data




### --- Поступление ТМЦ и ввод остатков ---
def	StoreOneIn(user_kod,one,barcode,store,q,okei,action,comment,model):
    user_kod = user_kod.encode("utf-8")
    one = one.encode("utf-8")
    barcode = barcode.encode("utf-8")
    store = store.encode("utf-8")
    okei = okei.encode("utf-8")
    action = action.encode("utf-8")
    model = model.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_StoreOneIn(%s,%s,%s,%s,%s,%s,%s,%s,%s);",[user_kod,one,barcode,store,q,okei,action,comment,model])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Остатки по складам ---
def	GetStoreRest(one_kod):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_rest WHERE one_kod=%s;",[one_kod])
    data = cursor.fetchall()

    return data




### --- Остатки по складам ---
def	GetStoreOneIn(one_kod,one_type):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_onein WHERE one_kod=%s AND type_one=%s LIMIT 50;",[one_kod,one_type])
    data = cursor.fetchall()

    return data



### --- Отмена поступления ТМЦ ---
def	StoreOneInCancel(user_id,rec_id):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_StoreOneInCancel(%s,%s);",[user_id,rec_id])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]



### --- Движения ---
def	GetStoreProcess(one_kod):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_process WHERE one_kod=%s LIMIT 50;",[one_kod])
    data = cursor.fetchall()

    return data



### --- Запись остатка или поступления ---
def	GetStoreOneInRow(rec_id):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_onein WHERE rec_id=%s;",[rec_id])
    data = cursor.fetchone()

    return data


### --- Информация по модели данных ---
def	GetStoreModelData(rec_id):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_store_model_data_list WHERE t_rec_id=%s;",[rec_id])
    data = cursor.fetchone()

    return data




### --- Получение списка Заявок ТМЦ ---
def	GetTmcList(search):    

    ### --- Предварительно обрабатываем строку поиска ---
    search = search.encode("utf-8")
    words = search.split()

    n = len(words)

    cursor = connections['default'].cursor()
    if n == 0:
	cursor.execute("""SELECT * FROM t_show_store_tmc WHERE grouptmc='common' AND (status_kod=11 OR status_kod=4 OR status_kod=13);""")
    elif n == 1:
	cursor.execute("""SELECT * FROM t_show_store_tmc WHERE grouptmc='common' AND (status_kod=11 OR status_kod=4 OR status_kod=13) AND \
	(\
	to_tsvector('russian',spec_name) @@ to_tsquery('russian',%s) OR \
	to_tsvector('russian',tema) @@ to_tsquery('russian',%s) OR \
	to_tsvector('russian',user1) @@ to_tsquery('russian',%s) OR \
	to_tsvector('russian',to_char(tmc_kod,'999999')) @@ to_tsquery('russian',%s) \
	);""" , [search,search,search,search])
    else:
	search = ' & '.join(words)
	cursor.execute("""SELECT * FROM t_show_store_tmc WHERE grouptmc='common' AND (status_kod=11 OR status_kod=4 OR status_kod=13) AND \
	to_tsvector('russian',spec_name) @@ to_tsquery('russian',%s) \
	;""" , [search])
    data = cursor.fetchall()

    return data



### --- Получение одной записи содержимого заявки ТМЦ ---
def	GetTmc(rec_id):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_tmc WHERE spec_kod=%s;", [rec_id])
    data = cursor.fetchone()

    return data



### --- Получение списка для выбора из имеющегося на складе по заявкам ТМЦ ---
def	GetStoreTmcList(person,okei):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT kod,name||' ('||store||' '||btrim(to_char(q,'9990.00'))||' '||okei||')' FROM t_show_store_tmceisup WHERE person_kod=%s AND okei_kod=%s AND q>0;", [person,okei])
    data = cursor.fetchall()

    return data



### --- Получение списка для выбора из имеющегося на складе по заявкам ТМЦ ---
def	GetStoreTmcListAll():    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT kod,name||' ('||store||' '||btrim(to_char(q,'9990.00'))||' '||okei||')' FROM t_show_store_tmceisup WHERE q>0;")
    data = cursor.fetchall()

    return data




### --- Резервирование по заявкам ТМЦ ---
def	StoreOneReserve(user_id,row_id,onein_id,q):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_StoreOneReserve(%s,%s,%s,%s);",[user_id,row_id,onein_id,q])
    transaction.commit_unless_managed()
    data = cursor.fetchone()
    return data[0]



### --- Получение списка резервов ---
def	GetStoreReserve(one_kod):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_reserve WHERE one_kod=%s LIMIT 50;", [one_kod])
    data = cursor.fetchall()

    return data


### --- Получение суммарных резервов по складам ---
def	GetStoreReserveSum(one_kod):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT store_name,okei,sum(reserve) FROM t_show_store_reserve WHERE one_kod=%s GROUP BY store_name,okei;", [one_kod])
    data = cursor.fetchall()

    return data


### --- Отмена резерва ---
def	DeleteReserve(rec_id):
    cursor = connections['default'].cursor()
    cursor.execute("DELETE FROM t_store_reserve WHERE t_rec_id=%s;",[rec_id])
    transaction.commit_unless_managed()



### --- Получение записи по резерву ---
def	GetStoreReserveData(rec_id):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_reserve WHERE rec_id=%s;", [rec_id])
    data = cursor.fetchone()

    return data


### --- Создание реализации ---
def	StoreOneOut(user_id,reserve_id,barcode,q,options):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_StoreOneOut(%s,%s,%s,%s,%s);",[user_id,reserve_id,barcode,q,options])
    transaction.commit_unless_managed()
    data = cursor.fetchone()
    return data[0]


### --- Получение списка реализаций ---
def	GetStoreOneOut(one_kod):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_oneout WHERE one_kod=%s LIMIT 50;", [one_kod])
    data = cursor.fetchall()

    return data


### --- Получение записи реализации ---
def	GetStoreOneOutData(rec_id):    
    cursor = connections['default'].cursor()
    cursor.execute("SELECT * FROM t_show_store_oneout WHERE rec_id=%s;", [rec_id])
    data = cursor.fetchone()

    return data


### --- Отмена реализации ТМЦ ---
def	StoreOneOutCancel(user_id,rec_id):
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_StoreOneOutCancel(%s,%s);",[user_id,rec_id])
    transaction.commit_unless_managed()
    data = cursor.fetchone()

    return data[0]

