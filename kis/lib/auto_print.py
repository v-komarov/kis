#coding:utf-8

import	json
import	urllib2

from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	reportlab.pdfgen	import	canvas
from	reportlab.lib.units	import	mm
from	reportlab.pdfbase	import	pdfmetrics
from	reportlab.pdfbase	import	ttfonts
from	reportlab.lib		import	colors
from	reportlab.lib.pagesizes	import	letter, A4, landscape

from	reportlab.platypus.tables	import	Table, TableStyle
from	reportlab.platypus.doctemplate	import	SimpleDocTemplate
from	reportlab.platypus.paragraph	import	Paragraph
from	reportlab.lib.styles		import	ParagraphStyle,getSampleStyleSheet
from	reportlab.platypus		import	Frame,Spacer

from	reportlab.platypus		import	Image

from	auto	import	GetATripTaskData
from	jsondata	import	JsonUser






### --- Печать заявки (печатная форма) ----    
def	PrintForm(buff,task_id):



    ### --- Получение данных ---
    # Заказ 
    task_data = GetATripTaskData(task_id)


    ### --- Тип автомобиля (легковой/грузовой) ---
    auto_type = task_data[12].encode("utf-8")


    ### --- Водитель ---
    if task_data[17] == '2':
	d = JsonUser(task_data[10])
	driver = d.j['name1'].encode("utf-8")+ ' '+d.j['name2'].encode("utf-8")+ ' ' +d.j['name3'].encode("utf-8")
    else:	
	driver = "___________________"



    ### --- Получение данных автора заявки (заказа) ---
    jauthor = JsonUser(task_data[21])

    ### --- Получение данных руководителя ---
    jchief = JsonUser(task_data[36])

    Font1 = ttfonts.TTFont('PT','kis/fonts/PTC55F.ttf')
    Font2 = ttfonts.TTFont('PTB','kis/fonts/PTC75F.ttf')
    Font3 = ttfonts.TTFont('PTI','kis/fonts/PTS56F.ttf')

    pdfmetrics.registerFont(Font1)
    pdfmetrics.registerFont(Font2)
    pdfmetrics.registerFont(Font3)


    style = getSampleStyleSheet()
    style.add(ParagraphStyle(name='Head',wordWrap=True,fontName='PTB',fontSize=14,spaceAfter=5*mm,spaceBefore=5*mm,alignment=1))
    style.add(ParagraphStyle(name='DepName',wordWrap=True,fontName='PTB',fontSize=10,spaceAfter=5*mm,spaceBefore=5*mm,alignment=1))
    style.add(ParagraphStyle(name='Data',wordWrap=True,fontName='PT',fontSize=8,spaceAfter=1*mm,spaceBefore=1*mm,alignment=0))

    style.add(ParagraphStyle(name='Right',wordWrap=True,fontName='PTB',fontSize=9,spaceAfter=0.1*mm,spaceBefore=0.1*mm,alignment=2))
    style.add(ParagraphStyle(name='Right2',wordWrap=True,fontName='PT',fontSize=8,spaceAfter=0.1*mm,spaceBefore=0.1*mm,alignment=2))
    style.add(ParagraphStyle(name='Left',wordWrap=True,fontName='PTB',fontSize=9,spaceAfter=0.1*mm,spaceBefore=0.1*mm,alignment=0))
    style.add(ParagraphStyle(name='Left_Space',wordWrap=True,fontName='PTB',fontSize=9,spaceAfter=15*mm,spaceBefore=0.1*mm,alignment=0))
    style.add(ParagraphStyle(name='Left2',wordWrap=True,fontName='PTB',fontSize=10,spaceAfter=0.1*mm,spaceBefore=0.1*mm,leftIndent=120*mm,alignment=0))
    style.add(ParagraphStyle(name='Center',wordWrap=True,fontName='PTB',fontSize=9,spaceAfter=0.1*mm,spaceBefore=0.1*mm,alignment=1))

    
    doc = SimpleDocTemplate(buff,topMargin=0.2*mm,bottomMargin=0.2*mm,leftMargin=10*mm,rightMargin=10*mm)

    elements = []

    elements.append(Paragraph('Приложение №1',style["Right"]))
    elements.append(Paragraph('(подается не позднее, чем за один рабочий день',style["Right2"]))
    elements.append(Paragraph('до даты предоставления автотранспорта)',style["Right2"]))
    elements.append(Paragraph('К исполнению: водитель <font face="PTI">%s</font> К путевому листу: ______' % driver,style["Left"]))
    elements.append(Paragraph('На автомобиле _______________________________________ ',style["Left"]))
    elements.append(Paragraph('_________________ Гл. механик А.Г.Науменко',style["Left"]))
    elements.append(Paragraph('Главному механику отдела',style["Left2"]))
    elements.append(Paragraph('АТО',style["Left2"]))
    elements.append(Paragraph('Науменко А.Г.',style["Left2"]))
    elements.append(Paragraph('Заявка от '+task_data[27].encode("utf-8"),style["Left"]))
    elements.append(Paragraph('на предоставление автотранспорта: <font face="PTI">%s</font>' % (jauthor.j['department'].encode("utf-8")),style["Left"]))



    Left = Paragraph("""    
    Информация\nиспользования\nавтомобиля\n
    """ ,style['Center'])


    Left2 = Paragraph("""    
    L общ. = ____км;
    Расход = ____литров;
    Тип автомобиля:
    (легковой -4 места; 
    м/автобус - 7 мест; 
    грузопассажирский -
    4 места и до 400 кг
    груза; грузовой - 1
    место и до 5000 кг
    груза)\n 
    """,style['Center'])


    Left3 = Paragraph("""    
    <font face="PTI">%s</font>
    """ % auto_type,style['Center'])


    Right = Paragraph("""
    Дата,время и адрес подачи автомобиля(время прибытия самолета/поезда,№ рейса):
    <font face="PTI">%s</font> __________________________________________________________________________________
    """ % task_data[1].encode("utf-8"),style['Left'])
    Right2 = Paragraph("""
    Маршрут движения автомобиля, цель поездки (не допускается использование общих фраз - служебные цели,служебная/производственная необходимость и т.д.) и период использования автомобиля (в часах): <font face="PTI">%s, %s, %s, %s ч.</font>
    """ % (task_data[7].encode("utf-8"),task_data[8].encode("utf-8"),task_data[41].encode("utf-8"),task_data[5].encode("utf-8")),style['Left'])
    Right3 = Paragraph("""
    """,style['Left_Space'])
    Right4 = Paragraph("""
    Ф.И.О.(имя и отчество полностью) и должность сотрудника, которому предоставляется автомобиль: <font face="PTI">%s %s %s %s</font>
    """ % (jauthor.j['name1'].encode("utf-8"),jauthor.j['name2'].encode("utf-8"),jauthor.j['name3'].encode("utf-8"),jauthor.j['job'].encode("utf-8")),style['Left'])
    Right5 = Paragraph("""Показания спидометра автомобиля, км: при посадке_________; при высадке_________
    """,style['Left'])


    Tdata = [
	    [[Left,Left2,Left3],[Right,Right2,Right3,Right4,Right5],"",""],
	    ["","Автомобиль(тип):","Пассажиры (чел):","Багаж (габариты,м):"],
	    ["","","",""],
	    ]
    
    TableHead=Table(Tdata,colWidths=[40*mm,50*mm,50*mm,50*mm],rowHeights=[60*mm,5*mm,7*mm])
    TableHead.setStyle([('FONTNAME',(0,0),(-1,-1),'PTB'),
		('FONTSIZE',(0,0),(-1,-1),8),
		('ALIGN',(0,0),(0,0),'CENTER'),
		('ALIGN',(0,1),(-1,-1),'LEFT'),
		('VALIGN',(0,0),(-1,-1),'TOP'),
		('GRID',(0,0),(-1,-1),0.25,colors.black),
		('SPAN',(1,0),(3,0)),
		('ALIGN',(1,1),(3,1),'CENTER'),
		('SPAN',(0,0),(0,2)),
		])

    elements.append(TableHead)

    footer = Paragraph("""<font face="PTI">%s</font> ЗАО "СибТрансТелеКом" ____________________ <font face="PTI">%s %s %s</font>
    """ % (jchief.j['job'].encode("utf-8"),jchief.j['name1'].encode("utf-8"),jchief.j['name2'].encode("utf-8"),jchief.j['name3'].encode("utf-8")),style['Left'])

    footer2 = Paragraph(""" "____" _________ 2013г. Подпись водителя, исполнившего заявку _________________ /________________/
    """,style['Left'])


    elements.append(footer)
    elements.append(footer2)


    doc.build(elements)

    return buff



