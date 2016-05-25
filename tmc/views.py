#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	SearchForm,NewTmcForm,EditTmcForm
from	kis.lib.tmc		import	GetTmcList,NewTmc,GetTmcData,GetTmcSpec,EditTmc



### --- Заявки ТМЦ ---
def	ListTmc(request):


    try:
	if CheckAccess(request,'2') != 'OK':
	    return render_to_response("tmc/notaccess/tmc.html")
    except:
	return HttpResponseRedirect('/')


    ### --- Востановление закладки ----
    try:
	mark = request.session['mark']
    except:
	mark = 'common'

    ### --- Закладки ---
    try:
	mark = request.GET['mark']
	request.session['mark'] = mark
    except:
	pass


    ### --- Получение номера страницы ---
    try:
	page = int(request.GET.get('page',1))
	request.session['page'] = page
    except:
	pass
	
    try:
	page = int(request.session['page'])
    except:
	page = 1



    try:
	search = request.session['search']
	status = request.session['status']
    except:
	search = ''
	status = ''



    if request.method == 'POST':
	
	form = SearchForm(request.POST)
	if form.is_valid():
	    search = form.cleaned_data['search']
	    status = form.cleaned_data['status']
	    request.session['search'] = search
	    request.session['status'] = status



    data = GetTmcList(search,mark,status)


    form = SearchForm(None)
    form.fields['search'].initial = search
    form.fields['status'].initial = status



    paginator = Paginator(data,50)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)


    c = RequestContext(request,{'mark':mark,'form':form,'data':data_page})
    c.update(csrf(request))
    return render_to_response("tmc/tmc.html",c)





### --- Новая заявка ---
def	TmcNew(request):


    if CheckAccess(request,'2') != 'OK':
	return render_to_response("tmc/notaccess/tmc.html")


    ### --- Востановление закладки ----
    try:
	mark = request.session['mark']
    except:
	mark = 'common'


    if request.method == 'POST':
	
	form = NewTmcForm(request.POST)
	if form.is_valid():
	    tema = form.cleaned_data['tema']
	    text = form.cleaned_data['text']
	    r = NewTmc(GetUserKod(request),tema,text,mark)
	    if r == 'OK':
		return HttpResponseRedirect("/tmc")
		

    form = NewTmcForm(None)


    c = RequestContext(request,{'mark':mark,'form':form})
    c.update(csrf(request))
    return render_to_response("tmc/tmcnew.html",c)






### --- Редактирование содержимого заявки ---
def	TmcEdit(request):


    if CheckAccess(request,'2') != 'OK':
	return render_to_response("tmc/notaccess/tmc.html")


    try:
	tmc_id = request.session['tmc_id']
    except:
	return HttpResponseRedirect("/tmc")


    if request.method == 'POST':
	
	form = EditTmcForm(request.POST)
	if form.is_valid():
	    tema = form.cleaned_data['tema']
	    text = form.cleaned_data['text']
	    r = EditTmc(tmc_id,tema,text)
	    if r == 'OK':
		return HttpResponseRedirect("/tmcdata")
		


    d = GetTmcData(tmc_id)
    data = GetTmcSpec(tmc_id)

    form = EditTmcForm(None)
    form.fields['tema'].initial = d[3]
    form.fields['text'].initial = d[4]

    c = RequestContext(request,{'d':d,'form':form,'data':data})
    c.update(csrf(request))
    return render_to_response("tmc/tmcedit.html",c)

