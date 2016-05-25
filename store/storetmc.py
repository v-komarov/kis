#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.store		import	GetTmcList,GetTmc,GetStoreTmcList,StoreOneReserve
from	forms			import	SearchForm,ChoiceTmcForm



### --- Список содержимого заявок ТМЦ ---
def	StoreTmc(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')

    ### --- Получение номера страницы ---
    try:
	page = request.GET['page']
	request.session['page'] = page
    except:
	pass
	
    try:
	page = request.session['page']
    except:
	page = '1'


    try:
	search = request.session['search']
    except:
	search = ''


    if request.method == 'POST':
	
	form = SearchForm(request.POST)
	if form.is_valid():
	    search = form.cleaned_data['search']
	    request.session['search'] = search



    data = GetTmcList(search)


    form = SearchForm(None)
    form.fields['search'].initial = search
    
    paginator = Paginator(data,100)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)


    c = RequestContext(request,{'form':form,'data':data_page})
    c.update(csrf(request))
    return render_to_response("store/storetmc.html",c)





### --- Форма для выбора остатков по заявкам ТМЦ ---
def	StoreTmcChoice(request):


    c = RequestContext(request,{})


    if request.method == 'GET':
	try:
	    spec = request.GET['spec']
	    request.session['spec'] = spec
	except:
	    pass

    try:
	spec = request.session['spec']
    except:
	pass



    if request.method == 'POST':
	
	form = ChoiceTmcForm(request.POST)
	if form.is_valid():
	    one = form.cleaned_data['one']
	    q = form.cleaned_data['q']
	    StoreOneReserve(GetUserKod(request),spec,one,q)



    spec_data = GetTmc(spec)
    onelist = GetStoreTmcList(GetUserKod(request),spec_data[2])
    onelist.insert(0,['',''])

    form = ChoiceTmcForm(None)
    form.fields['q'].initial = 0.00
    form.fields['one'].choices = onelist
    form.fields['one'].initial = ''

    c = RequestContext(request,{'form':form,'spec_data':spec_data})


    c.update(csrf(request))
    return render_to_response("store/choicetmc.html",c)


