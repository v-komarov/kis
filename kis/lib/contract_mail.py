#coding:utf-8

from	django.db		import	connections, transaction
from	django.core.mail	import	send_mail
from	kis.lib.contract	import	GetDData,WriteEmailRuk,EmailHistory,GetGroupEmail,GetAuthorEmail,GetDPersonNextEmail,PersonEmailOk,PersonLagDays,GetDStatus



### --- Список адресов группы рассылки ---
def	Emails():
    mail_list = GetGroupEmail()
    m = []
    for item in mail_list:
	m.append(item[0])

    return m



### --- Отправка запроса подписи ---
def	Email2Ruk(email,contract_id):

    data = GetDData(contract_id)

    address = []
    address.append(email)
    m = u"""\
    Прошу подписать заявку № %s (Заявки договоры)\n\n\
    Контрагент: %s\n\
    Тема: %s\n\
    Содержание заявки:\n
    %s\
    """ % (data[0],data[3],data[4],data[8])
    send_mail('KIS-messager D '+data[0],m,data[14],address)

    ### --- Фиксируем email в заявке ---
    WriteEmailRuk(contract_id,email)
    ### -- Собираем отправку в лог ---
    EmailHistory(contract_id,email,u'Запрос на подпись заявки')






#### --- Рассылка уведомлений по статусу заявки ---
def	EmailStatusInfo(contract_id):
    ### --- Получение данных по заявке ---
    d = GetDData(contract_id)
    
    ### --- Получение последнего установленного статуса из истории статусов ---
    last_status = GetDStatus(contract_id)[0]

    ### --- Для статусов Комментарий и Договор не согласован рассылку не делаем ---
    #if d[5] != '3' and d[5] != '6':

    mail = Emails()
    mail.append(d[14])
    author = GetAuthorEmail()

    ### --- уточнение статуса заявки для процесса согласования ---
    

    for address in mail:

	m = u"""\
	Заявки договоры\n\n\
	Уведомление о статусе заявки № %s\n\
	Контрагент: %s\n\
	Тема: %s\n\n\
	Статус: %s\n\
	Сообщение: %s\n\
	Автор: %s %s\
	""" % (d[0],d[3],d[4],last_status[3],last_status[2],last_status[7],last_status[6])
	send_mail('KIS-messager D '+d[0],m,author,[address,])

	EmailHistory(contract_id,address,u'Уведомление о статусе: '+last_status[3])





### --- Приглашение к согласованию версии договора ---
def	EmailToPerson(contract_id):

    ### --- Получение данных по заявке ---
    d = GetDData(contract_id)
    author = GetAuthorEmail()

    ### --- Определение следующего согласующего ---
    try:
	(person_kod,email,send) = GetDPersonNextEmail(contract_id)
    except:
	(person_kod,email,send) = ['','','']
    ### --- Проверка : отправлялось ли уже сообщение этому согласующиму ---
    if send == 'NO':

	m = u"""\
	Заявки договоры\n\n\
	Уведомление о необходимости согласования заявки № %s\n\
	Контрагент: %s\n\
	Тема: %s\n\n\
	Предлагаем согласовать версию договора.
	""" % (d[0],d[3],d[4])
	send_mail('KIS-messager D '+d[0],m,author,[email,])

	EmailHistory(contract_id,email,u'Уведомление согласующиму.')

	### --- Отметка, что email согласующему отправлен ---
	PersonEmailOk(contract_id,person_kod)






#### --- Напоминатель согласователям ---
def	Remember(days=3):
    data = PersonLagDays(days)
    author = GetAuthorEmail()
    for item in data:
	day_str = "%s" % item[0]
	d = GetDData(day_str)
	email = item[6]

	m = u"""\
	Заявки договоры\n\n\
	Напоминание о необходимости согласования заявки № %s\n\
	Контрагент: %s\n\
	Тема: %s\n\n\
	Предлагаем согласовать версию договора.
	""" % (d[0],d[3],d[4])
	send_mail('KIS-messager D '+d[0],m,author,[email,])

	EmailHistory(d[0],email,u'Напоминание согласующиму.')

