#coding:utf-8

import	xlwt

from	kis.lib.auto	import	GetReport0,GetReport0sum


### --- Отчет Контроль рабочего времени ---
def	Report_0(response,start_date,end_date):


    book = xlwt.Workbook(encoding='utf-8')
    sheet = book.add_sheet('Report')

    default_style = xlwt.Style.default_style

    sheet.col(1).width = 256*50
    sheet.col(2).width = 256*30
    sheet.col(3).width = 256*50
    sheet.col(4).width = 256*20
    
    style = xlwt.easyxf('font: bold 1')
    sheet.write(0,0,'Контроль рабочего времени за период с %s по %s' % (start_date,end_date),style)

    sheet.write(2,0,'Дата',style)
    sheet.write(2,1,'Маршрут',style)
    sheet.write(2,2,'Объект',style)
    sheet.write(2,3,'Водитель',style)
    sheet.write(2,4,'Длительность (часы)',style)

    data = GetReport0(start_date,end_date)
    datasum = GetReport0sum(start_date,end_date)

    i = 4
    for row in data:
	sheet.write(i,0,row[1])
	sheet.write(i,1,row[3])
	sheet.write(i,2,row[4])
	sheet.write(i,3,row[5])
	sheet.write(i,4,row[2])
	i = i + 1
    
    
    i = i + 3
    sheet.write(i,3,'Суммарные значения',style)
    i = i + 1
    for row in datasum:
	sheet.write(i,3,row[0])
	sheet.write(i,4,row[1])
	i = i + 1
	


    book.save(response)
    return response




