#coding:utf-8
import	xlwt


### --- Данные для отчета IT ---
def	ItReportFile(start_date,end_date,response,data):

    font0 = xlwt.Font()
    font0.name = 'Times New Roman'
    font0.colour_index = 0
    font0.bold = True


    font1 = xlwt.Font()
    font1.name = 'Times New Roman'
    font1.colour_index = 0

    
    style0 = xlwt.XFStyle()
    style0.font = font0

    style1 = xlwt.XFStyle()
    style1.font = font1
    
    wb = xlwt.Workbook(encoding='utf-8')
    ws = wb.add_sheet('Report')
    
    ws.write(0,0,u"Отчет ItHelpDesk за период с %s по %s" % (start_date,end_date), style0)

    ws.write(2,0,u'Исполнитель',style0)
    ws.write(2,1,u'Телефон',style0)
    ws.write(2,2,u'Всего заявок',style0)
    ws.write(2,3,u'Всего трудоёмкость',style0)
    ws.write(2,4,u'Выполнено заявок',style0)
    ws.write(2,5,u'Трудоёмкость выполненных',style0)
    ws.write(2,6,u'% выполненения',style0)
    y = 3
    
    for row in data:
	ws.write(y,0,row[0],style1)
	ws.write(y,1,row[1],style1)
	ws.write(y,2,row[2],style1)
	ws.write(y,3,row[3],style1)
	ws.write(y,4,row[4],style1)
	ws.write(y,5,row[5],style1)
	ws.write(y,6,row[6],style1)
	
	y = y + 1
	
    wb.save(response)

    return response

