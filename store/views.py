#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	forms			import	SearchForm
from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.store		import	GetList



### --- Список номенклатуры ---
def	List(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



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
    except:
	search = ''



    if request.method == 'POST':
	
	form = SearchForm(request.POST)
	if form.is_valid():
	    search = form.cleaned_data['search']
	    request.session['search'] = search



    data = GetList(search)


    form = SearchForm(None)
    form.fields['search'].initial = search

    paginator = Paginator(data,100)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)

    c = RequestContext(request,{'form':form,'data':data_page})
    c.update(csrf(request))
    return render_to_response("store/list.html",c)







