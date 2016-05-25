#coding:utf-8

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


from	kis.lib.contract	import	FIO_Job_Person


### --- pdf file для штампа согласования ---
def	Stamp(buff,d_id,person):
    
    ### --- Список согласователей ---
    per = FIO_Job_Person(person)

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
    
    doc = SimpleDocTemplate(buff,topMargin=10*mm,bottomMargin=10*mm,leftMargin=20*mm,rightMargin=10*mm)

    elements = []

    elements.append(Paragraph('КИС Договоры заявки',style["Head"]))
    elements.append(Paragraph('Номер заявки '+str(d_id),style["Head"]))


    Tdata = [['Участники договорной\nработы','ФИО лица,\nзавизировавшего договор'],]

    author = per[0]
    Tdata.append([Paragraph(u'Ответственный исполнитель, '+author[0],style["Data"]),Paragraph(author[1],style["Data"])],)
    
    for item in per[1:]:
	Tdata.append([Paragraph(item[0],style["Data"]),Paragraph(item[1],style["Data"])],)
    
    TableHead=Table(Tdata)
    TableHead.setStyle([('FONTNAME',(0,0),(-1,-1),'PTB'),
		('FONTSIZE',(0,0),(-1,-1),10),
		('ALIGN',(0,0),(-1,0),'CENTER'),
		('ALIGN',(0,1),(-1,-1),'LEFT'),
		('VALIGN',(0,0),(-1,-1),'MIDDLE'),
		('GRID',(0,0),(-1,-1),0.25,colors.black),
		])


    elements.append(TableHead)



    doc.build(elements)

    return buff
