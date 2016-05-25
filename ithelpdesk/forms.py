#coding:utf-8
import	datetime
from	django	import	forms
from	django.forms.extras.widgets	import	SelectDateWidget

from	kis.lib.ithelpdesk	import	GetItUserList,GetIspList,GetStatusList,GetCategoryList



### --- Форма добавления администратора ---
class	AdminForm(forms.Form):
    admin = forms.ChoiceField(label='Выбор *',choices=GetItUserList())
    def	__init__(self,*args,**kwargs):
	super(AdminForm,self).__init__(*args,**kwargs)
	self.fields['admin'].choices = GetItUserList()


### --- Обратный email адрес ---
class	EmailAddressForm(forms.Form):
    email = forms.EmailField(label='Адрес *')


### --- Поиск ---
class	SearchForm(forms.Form):
    search = forms.CharField(label='Строка поиска',required=False)


class	TaskEditForm(forms.Form):
    tema = forms.CharField(label='Тема *')
    work = forms.IntegerField(label='Трудоемкость(чел./ч.)')
    comment = forms.CharField(label='Коментарий',widget=forms.Textarea,required=False)
    isp = forms.ChoiceField(label='Исполнитель',choices=GetIspList())
    status = forms.ChoiceField(label='Статус',choices=GetStatusList())
    category = forms.ChoiceField(label='Категория',choices=GetCategoryList())
    file_load = forms.FileField(label='Приложить файл',widget=forms.FileInput,required=False)

    def	__init__(self,*args,**kwargs):
	super(TaskEditForm,self).__init__(*args,**kwargs)
	self.fields['isp'].choices = GetIspList()


### --- Форма для создания новой заявки администартивной группой ---
class	TaskNewForm(forms.Form):
    tema = forms.CharField(label='Тема *')
    task = forms.CharField(label='Содержание заявки *',widget=forms.Textarea)
    work = forms.IntegerField(label='Трудоемкость(чел./ч.) *')
    isp = forms.ChoiceField(label='Исполнитель *',choices=GetIspList())
    category = forms.ChoiceField(label='Категория',choices=GetCategoryList())
    user = forms.ChoiceField(label='Пользователь *',choices=GetItUserList())

    def	__init__(self,*args,**kwargs):
	super(TaskNewForm,self).__init__(*args,**kwargs)
	self.fields['isp'].choices = GetIspList()
	self.fields['user'].choices = GetItUserList()



### --- Форма клонирования заявки администартивной группой ---
class	TaskCloneForm(forms.Form):
    tema = forms.CharField(label='Тема *')
    task = forms.CharField(label='Содержание заявки *',widget=forms.Textarea)
    work = forms.IntegerField(label='Трудоемкость(чел./ч.) *')
    isp = forms.ChoiceField(label='Исполнитель *',choices=GetIspList())
    category = forms.ChoiceField(label='Категория *',choices=GetCategoryList())

    def	__init__(self,*args,**kwargs):
	super(TaskCloneForm,self).__init__(*args,**kwargs)
	self.fields['isp'].choices = GetIspList()




### --- Форма для создания новой заявки пользователем ---
class	TaskNewUserForm(forms.Form):
    task = forms.CharField(label='Содержание заявки *',widget=forms.Textarea)



### --- Форма добавления нового сообщения пользователем ---
class	MessNewUserForm(forms.Form):
    mess = forms.CharField(label='Текст сообщения *',widget=forms.Textarea)
    file_load = forms.FileField(label='Приложить файл',widget=forms.FileInput,required=False)


### --- Отчеты ---
class	ReportForm(forms.Form):
    start_date = forms.DateField(label='С *',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
    end_date = forms.DateField(label='по *',widget=SelectDateWidget(years=[2013,]),initial=datetime.date.today())
