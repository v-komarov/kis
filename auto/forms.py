#coding:utf-8

import	datetime

from	django	import	forms
from	django.forms.extras.widgets	import	SelectDateWidget

from	kis.lib.auto	import	GetChoiceDriverList,GetAutoTypeList,GetAutoFuelList,GetAutoTaskList,GetDriverChoiceList,GetChiefCFOList,GetAStatusAllList,GetCFORukEmailList,GetAuStatusList


hours = (
('06:30','06:30'),
('07:00','07:00'),
('07:30','07:30'),
('08:00','08:00'),
('08:30','08:30'),
('09:00','09:00'),
('09:30','09:30'),
('10:00','10:00'),
('10:30','10:30'),
('11:00','11:00'),
('11:30','11:30'),
('13:00','13:00'),
('13:30','13:30'),
('14:00','14:00'),
('14:30','14:30'),
('15:00','15:00'),
('15:30','15:30'),
('16:00','16:00'),
('16:30','16:30'),
('17:00','17:00'),
('17:30','17:30'),
)

report_list = (
('0','Контроль рабочего времени'),
)

### --- Добавление водителя ---
class	AddDriverForm(forms.Form):
    driver = forms.ChoiceField(label='Ф.И.О.*',choices=GetChoiceDriverList())
    location = forms.CharField(label='Город/ЭТЦ *')
    license = forms.CharField(label='Удостоверение *')
    category = forms.CharField(label='Категории *')


### --- Поиск ---
class	SearchForm(forms.Form):
    search = forms.CharField(label='Строка поиска',required=False)


### --- Добавление автомобиля ---
class	AddAutoForm(forms.Form):
    location = forms.CharField(label='Город/ЭТЦ *')
    mark = forms.CharField(label='Марка *')
    auto_type = forms.ChoiceField(label='Тип *',choices=GetAutoTypeList())
    status = forms.ChoiceField(label='Статус *',choices=GetAuStatusList())
    g_number = forms.CharField(label='Гос номер *')
    auto_fuel = forms.ChoiceField(label='Топливо *',choices=GetAutoFuelList())
    fuel_s = forms.DecimalField(label='Летний расход л./100км *',max_digits=5,decimal_places=2)
    fuel_w = forms.DecimalField(label='Зимний расход л./100км *',max_digits=5,decimal_places=2)



### --- Форма для создания нового заказа ---
class	NewTaskForm(forms.Form):
    start_date = forms.DateField(label='Дата/время (с)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    start_time = forms.ChoiceField(choices=hours)
    end_date = forms.DateField(label='Дата/время (по)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_time = forms.ChoiceField(choices=hours)
    route = forms.CharField(label='Маршрут *',widget=forms.TextInput(attrs={'class':'g-4',}))
    place = forms.CharField(label='Объект *',widget=forms.TextInput(attrs={'class':'g-4',}))
    auto = forms.ChoiceField(label='Автомобиль *',choices=GetAutoTaskList(option='shot'))
    target = forms.CharField(label='Цель *',widget=forms.TextInput(attrs={'class':'g-4',}))

    def	__init__(self,*args,**kwargs):
	super(NewTaskForm,self).__init__(*args,**kwargs)
	self.fields['auto'].choices = GetAutoTaskList(option='shot')




### --- Форма для редактирования заказа ---
class	EditTaskForm(forms.Form):
    start_date = forms.DateField(label='Дата/время *',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    start_time = forms.ChoiceField(choices=hours)
    end_date = forms.DateField(label='Дата/время (по)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_time = forms.ChoiceField(choices=hours)
#    time = forms.IntegerField(label='Продолжительность (часы) *',widget=forms.TextInput(attrs={'class':'g-1',}))
    route = forms.CharField(label='Маршрут *',widget=forms.TextInput(attrs={'class':'g-4',}))
    place = forms.CharField(label='Объект *',widget=forms.TextInput(attrs={'class':'g-4',}))
    auto = forms.ChoiceField(label='Автомобиль *',choices=GetAutoTaskList(option='shot'))
    target = forms.CharField(label='Цель *',widget=forms.TextInput(attrs={'class':'g-4',}))
    status = forms.ChoiceField(label='Статус *',choices=GetAStatusAllList(),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea,required=False)

    def	__init__(self,*args,**kwargs):
	super(EditTaskForm,self).__init__(*args,**kwargs)
	self.fields['auto'].choices = GetAutoTaskList(option='shot')
	self.fields['status'].choices = GetAStatusAllList()




### --- Форма отправки email руководителю ---
#class	EmailForm(forms.Form):
#    email = forms.ChoiceField(label='Выбор получателя сообщения',required=False,choices=GetEmailRukList())


### --- Email обратного адреса ---
class	EmailAuthorForm(forms.Form):
    authoremail = forms.EmailField(label='Обратный адрес')


### --- Ввод адреса рассылки ---
class	EmailGroupForm(forms.Form):
    groupemail = forms.EmailField(label='Адрес рассылки')



### --- Форма задания начала сезона ---
class	NewSeasonFormS(forms.Form):
    start_date_s = forms.DateField(label='Дата *',widget=SelectDateWidget(years=[2013,2014,]),initial=datetime.date.today())


### --- Форма задания начала сезона ---
class	NewSeasonFormW(forms.Form):
    start_date_w = forms.DateField(label='Дата *',widget=SelectDateWidget(years=[2013,2014,]),initial=datetime.date.today())


### --- Добавление расхода топлива с прицепом ---
class	AddAutoTrailerForm(forms.Form):
    fuel_s = forms.DecimalField(label='Летний расход л./100км *',max_digits=5,decimal_places=2)
    fuel_w = forms.DecimalField(label='Зимний расход л./100км *',max_digits=5,decimal_places=2)



### --- Форма для создания нового планового выезда ---
class	NewPlanForm(forms.Form):
    start_date = forms.DateField(label='Дата/время (с)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    start_time = forms.ChoiceField(choices=hours)
    end_date = forms.DateField(label='Дата/время (по)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_time = forms.ChoiceField(choices=hours)
    route = forms.CharField(label='Маршрут *',widget=forms.TextInput(attrs={'class':'g-4',}))
    place = forms.CharField(label='Объект *',widget=forms.TextInput(attrs={'class':'g-4',}))
    driver = forms.ChoiceField(label='Водитель *',choices=GetDriverChoiceList())
    auto = forms.ChoiceField(label='Автомобиль *',choices=GetAutoTaskList(option='middle'))
    target = forms.CharField(label='Цель *',widget=forms.TextInput(attrs={'class':'g-4',}))
    traveler = forms.CharField(label='Попутчик ',widget=forms.TextInput(attrs={'class':'g-4',}),required=False)
    trailer = forms.CharField(label='Прицеп ',widget=forms.CheckboxInput)
    chief = forms.ChoiceField(label='Руководитель ЦФО *',choices=GetChiefCFOList())

    def	__init__(self,*args,**kwargs):
	super(NewPlanForm,self).__init__(*args,**kwargs)
	self.fields['auto'].choices = GetAutoTaskList(option='middle')
	self.fields['driver'].choices = GetDriverChoiceList()
	self.fields['chief'].choices = GetChiefCFOList()




### --- Форма планового выезда ---
class	EditPlanForm(forms.Form):
    start_date = forms.DateField(label='Дата/время (с)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    start_time = forms.ChoiceField(choices=hours)
    end_date = forms.DateField(label='Дата/время (по)*',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_time = forms.ChoiceField(choices=hours)
    time = forms.IntegerField(label='Продолжительность (часы) *',widget=forms.TextInput(attrs={'class':'g-1',}))
    route = forms.CharField(label='Маршрут *',widget=forms.TextInput(attrs={'class':'g-4',}))
    place = forms.CharField(label='Объект *',widget=forms.TextInput(attrs={'class':'g-4',}))
    driver = forms.ChoiceField(label='Водитель *',choices=GetDriverChoiceList())
    auto = forms.ChoiceField(label='Автомобиль *',choices=GetAutoTaskList(option='middle'))
    target = forms.CharField(label='Цель *',widget=forms.TextInput(attrs={'class':'g-4',}))
    traveler = forms.CharField(label='Попутчик ',widget=forms.TextInput(attrs={'class':'g-4',}),required=False)
    trailer = forms.CharField(label='Прицеп ',widget=forms.CheckboxInput)
    chief = forms.ChoiceField(label='Руководитель ЦФО *',choices=GetChiefCFOList())
    speedo1 = forms.IntegerField(label='Спидометр (до) *')
    speedo2 = forms.IntegerField(label='Спидометр (после) *')
    fuel = forms.DecimalField(label='Расход топлива (л) *',max_digits=6,decimal_places=2)
    status = forms.ChoiceField(label='Статус *',choices=GetAStatusAllList(),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea,required=False)

    def	__init__(self,*args,**kwargs):
	super(EditPlanForm,self).__init__(*args,**kwargs)
	self.fields['auto'].choices = GetAutoTaskList(option='middle')
	self.fields['driver'].choices = GetDriverChoiceList()
	self.fields['status'].choices = GetAStatusAllList()
	self.fields['chief'].choices = GetChiefCFOList()


### --- Форма запроса подписи заказа у руководителя ---
class	TaskChiefForm(forms.Form):
    chief = forms.ChoiceField(label='Руководитель ЦФО *',choices=GetCFORukEmailList())
    def	__init__(self,*args,**kwargs):
	super(TaskChiefForm,self).__init__(*args,**kwargs)
	chief = forms.ChoiceField(label='Руководитель ЦФО *',choices=GetCFORukEmailList())



### --- Выезды по заказам ---
class	EditTaskForm2(EditPlanForm):
    time = forms.IntegerField(label='Продолжительность (часы) *',widget=forms.TextInput(attrs={'class':'g-1',}),required=False)
    auto = forms.ChoiceField(label='Автомобиль *',choices=GetAutoTaskList(option='full'))
    chief = forms.ChoiceField(label='Руководитель ЦФО *',choices=GetChiefCFOList(),required=False)

    def	__init__(self,*args,**kwargs):
	super(EditPlanForm,self).__init__(*args,**kwargs)
	self.fields['auto'].choices = GetAutoTaskList(option='full')
	self.fields['driver'].choices = GetDriverChoiceList()
	self.fields['status'].choices = GetAStatusAllList()
    

### --- Форма для выбора отчета ---
class	ReportForm(forms.Form):
    start_date = forms.DateField(label='С *',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_date = forms.DateField(label='По *',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    report = forms.ChoiceField(label='Отчет *',choices=report_list)
    

### --- Форма для задания нового статуса ---
class	SetAuStatusForm(forms.Form):
    status = forms.ChoiceField(label='Статус *',choices=GetAuStatusList())


### --- Добавление/редактирование личного автомобиля ---
class	PersonAutoForm(forms.Form):
    location = forms.CharField(label='Город/ЭТЦ *')
    mark = forms.CharField(label='Марка *')
    g_number = forms.CharField(label='Гос номер *')
    auto_type = forms.ChoiceField(label='Тип *',choices=GetAutoTypeList())


### --- Форма добавления инструции ---
class	GuideForm(forms.Form):
    guide = forms.CharField(label='Наименование *',widget=forms.Textarea)
    file_load = forms.FileField(label='Приложить файл *',widget=forms.FileInput,required=False)

