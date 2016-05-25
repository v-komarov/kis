#coding:utf-8

from	django.db		import	connections, transaction
from	django.core.mail	import	send_mail
from	kis.lib.auto		import	GetANewTaskTripData,WriteEmailRuk,EmailHistory,GetGroupEmail,GetAuthorEmail



### --- Список адресов группы рассылки ---
def	Emails():
    mail_list = GetGroupEmail()
    m = []
    for item in mail_list:
	m.append(item[0])

    return m



### --- Отправка запроса подписи ---
def	Email2Ruk(email,trip_id):

    data = GetANewTaskTripData(trip_id)

    address = []
    address.append(email)
    m = u"""\
    Прошу подписать заказ (Автотранспорт)\n\n\
    Дата : %s Время: %s\n\
    Продолжительность(часы): %s\n\
    Маршрут: %s\n\
    Объект: %s\
    """ % (data[2],data[3],data[5],data[6],data[7])
    ### --- Отправка только для статуса "Заказ" --
    if data[8] == '0':
	send_mail('KIS-messager',m,data[20],address)

	### --- Фиксируем email в заказе ---
	WriteEmailRuk(trip_id,email)
	### -- Собираем отправку в лог ---
	EmailHistory(trip_id,email,u'Запрос на подпись руководителя ЦФО')






#### --- Рассылка уведомлений по статусу заявки ---
def	EmailStatusInfo(trip_id):
    ### --- Получение данных по заявке ---
    d = GetANewTaskTripData(trip_id)
    
    ### --- Делаем рассылку для статусов : подписан  ---
    if d[8] == '1' or d[8] == '2' or d[8] == '3' or d[8] == '4' or d[8] == '5' or d[8] == '8':

	mail = Emails()
	mail.append(d[20])
	author = GetAuthorEmail()
	
	for address in mail:

	    m = u"""\
	    Уведомление о статусе (Автотранспорт)\n\n\
	    Дата : %s Время: %s\n\
	    Продолжительность(часы): %s\n\
	    Маршрут: %s\n\
	    Объект: %s\n\n\
	    Статус: %s\
	    """ % (d[2],d[3],d[5],d[6],d[7],d[9])
	    send_mail('KIS-messager',m,author,[address,])

	    EmailHistory(trip_id,address,u'Уведомление о статусе: '+d[9])




