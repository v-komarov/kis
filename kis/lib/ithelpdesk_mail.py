#coding:utf-8

from	django.db		import	connections, transaction
from	django.core.mail	import	send_mail
from	kis.lib.ithelpdesk	import	GetAuthorEmail,GetGroupEmail,GetItTaskData,EmailHistory,GetItTaskStatusData,GetItTaskMessData



### --- Список адресов группы рассылки ---
def	Emails():
    mail_list = GetGroupEmail()
    m = []
    for item in mail_list:
	m.append(item[0])

    return m




### --- Уведомдление о создании новой заявки ---
def	EmailNewTask(task_id):

    ### --- получение данных заявки ---
    d = GetItTaskData(task_id)

    mail = Emails()
    mail.append(d[20])
    author = GetAuthorEmail()
	
    for address in mail:

	m = u"""\
	Зарегистрирована новая заявка в ItHelpDesk\n\n\
	Номер : %s\n\
	Дата : %s Время: %s\n\
	Содержание : %s\n\n\
	Пользователь : %s\n\
	Телефон : %s\
	""" % (d[1],d[3],d[4],d[17],d[18],d[19])
	send_mail('ItHelpDesk',m,author,[address,])

	EmailHistory(task_id,address,u'Зарегистрирована новая заявка')





### --- Уведомдление о текущем статусе ---
def	EmailStatusTask(rec_id):
    
    ### --- получение данных по последнему статусу ---
    s = GetItTaskStatusData(rec_id)

    ### --- получение данных заявки ---
    d = GetItTaskData(s[1])

    mail = Emails()
    mail.append(d[20])
    author = GetAuthorEmail()
	
    for address in mail:

	m = u"""\
	Заявка в ItHelpDesk\n\n\
	Номер : %s\n\
	Дата : %s Время: %s\n\
	Содержание : %s\n\n\
	Пользователь : %s\n\
	Телефон : %s\n\n\
	Статус : %s\n\
	Исполнитель (телефон) : %s %s (%s)\n\
	Сообщение : %s\n\
	Приложение : %s\
	""" % (d[1],d[3],d[4],d[17],d[18],d[19],d[14],d[9],d[8],d[11],s[4],s[14])
	send_mail('ItHelpDesk',m,author,[address,])

	EmailHistory(s[1],address,u'О текущем статусе заявки : '+d[14])








### --- Уведомдление о сообщении пользователя ---
def	EmailMessTask(rec_id):
    
    ### --- получение данных по последнему статусу ---
    s = GetItTaskMessData(rec_id)

    ### --- получение данных заявки ---
    d = GetItTaskData(s[1])

    mail = Emails()
    mail.append(d[20])
    author = GetAuthorEmail()
	
    for address in mail:

	m = u"""\
	Заявка в ItHelpDesk\n\n\
	Номер : %s\n\
	Дата : %s Время: %s\n\
	Содержание : %s\n\n\
	Пользователь : %s\n\
	Телефон : %s\n\n\
	Статус : %s\n\
	Исполнитель (телефон) : %s %s (%s)\n\n\
	Сообщение : %s\n\
	Приложение : %s\
	""" % (d[1],d[3],d[4],d[17],d[18],d[19],d[14],d[9],d[8],d[11],s[6],s[5])
	send_mail('ItHelpDesk',m,author,[address,])

	EmailHistory(s[1],address,u'Сообщение пользователя')
