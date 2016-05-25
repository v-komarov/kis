#coding:utf-8
import	datetime
from	django	import	forms
from	django.forms.extras.widgets	import	SelectDateWidget

from	kis.lib.store	import	GetPersonList,GetStoreListForm,GetModelDataList,GetOkeiList,GetStoreTmcListAll


modeldata = GetModelDataList()



### --- Поиск ---
class	SearchForm(forms.Form):
    search = forms.CharField(label='Строка поиска',required=False)


### --- Ввод нового склада или корректировка названия сущетвующего ---
class	StoreNameForm(forms.Form):
    name = forms.CharField(label='Склад *',widget=forms.TextInput(attrs={'class':'g-5',}))


### --- Создание кладовщика ---
class	StorePersonForm(forms.Form):
    person = forms.ChoiceField(label='ФИО *',choices=GetPersonList())
    store = forms.ChoiceField(label='Склад *',choices=GetStoreListForm())

    def	__init__(self,*args,**kwargs):
	super(StorePersonForm,self).__init__(*args,**kwargs)
	self.store = GetStoreListForm()
	self.store.insert(0,['0',''])
	self.persons = GetPersonList()
	self.persons.insert(0,['',''])
	self.fields['person'].choices = self.persons
	self.fields['store'].choices = self.store



### --- Модель данных ---
class	ModelDataForm(forms.Form):
    modeldata = forms.ChoiceField(label='Модель данных *',choices=modeldata)

    def	__init__(self,*args,**kwargs):
	super(ModelDataForm,self).__init__(*args,**kwargs)
	self.fields['modeldata'].choices = modeldata



### --- Для поступления или ввода остатков простой модели данных ---
class	OneInSimple(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    store = forms.ChoiceField(label='Склад *',choices= GetStoreListForm())
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    okei = forms.ChoiceField(label='Ед. изм. *',choices=GetOkeiList())
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)

    def	__init__(self,*args,**kwargs):
	super(OneInSimple,self).__init__(*args,**kwargs)
	self.storelist = GetStoreListForm()
	self.storelist.insert(0,['0',''])
	self.fields['store'].choices = self.storelist



### --- Для поступления или ввода остатков модели данных активного сетевого оборудования ---
class	OneInNetDevice(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    store = forms.ChoiceField(label='Склад *',choices=GetStoreListForm())
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    okei = forms.ChoiceField(label='Ед. изм. *',choices=GetOkeiList())
    invnumber = forms.CharField(label='Инв-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    sernumber = forms.CharField(label='Сер-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    mac = forms.CharField(label='MAC ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    hardware = forms.CharField(label='HardWare ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    software = forms.CharField(label='SoftWare ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)

    def	__init__(self,*args,**kwargs):
	super(OneInNetDevice,self).__init__(*args,**kwargs)
	self.storelist = GetStoreListForm()
	self.storelist.insert(0,['0',''])
	self.fields['store'].choices = self.storelist



### --- Для поступления или ввода остатков модели данных ТМЦ общего назначения ---
class	OneInAdmin(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    store = forms.ChoiceField(label='Склад *',choices=GetStoreListForm())
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    okei = forms.ChoiceField(label='Ед. изм. *',choices=GetOkeiList())
    invnumber = forms.CharField(label='Инв-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    sernumber = forms.CharField(label='Сер-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)

    def	__init__(self,*args,**kwargs):
	super(OneInAdmin,self).__init__(*args,**kwargs)
	self.storelist = GetStoreListForm()
	self.storelist.insert(0,['0',''])
	self.fields['store'].choices = self.storelist



### --- Выбор по остаткам для заявок ТМЦ ---
class	ChoiceTmcForm(forms.Form):
    one = forms.ChoiceField(label='Номенклатура *',choices=[])
    q = forms.DecimalField(label='Кол-во *',decimal_places=2,min_value=1,widget=forms.TextInput(attrs={'class':'g-1',}))

    def	__init__(self,*args,**kwargs):
	super(ChoiceTmcForm,self).__init__(*args,**kwargs)
	self.fields['one'].choices = GetStoreTmcListAll()



### --- Для реализации простой модели данных ---
class	OneOutSimple(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)



### --- Для реализации модели данных активного сетевого оборудования ---
class	OneOutNetDevice(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    invnumber = forms.CharField(label='Инв-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    sernumber = forms.CharField(label='Сер-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    mac = forms.CharField(label='MAC ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    hardware = forms.CharField(label='HardWare ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    software = forms.CharField(label='SoftWare ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)



### --- Для реализации модели данных ТМЦ общего назначения ---
class	OneOutAdmin(forms.Form):
    barcode = forms.CharField(label='ШтрихКод ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    q = forms.DecimalField(label='Кол-во *',decimal_places=2)
    invnumber = forms.CharField(label='Инв-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    sernumber = forms.CharField(label='Сер-й ном. ',widget=forms.TextInput(attrs={'class':'g-3',}),required=False)
    comment = forms.CharField(label='Комментарий',widget=forms.Textarea(attrs={'class':'g-5',}),required=False)


