#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	StoreNameForm
from	kis.lib.store		import	AddStoreName,GetStoreList,GetStoreName,EditStoreName



### --- Список складов ---
def	StoreList(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')


    data = GetStoreList()


    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("store/storelist.html",c)




### --- Новый склад ---
def	StoreNew(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')

    if request.method == 'POST':
	
	form = StoreNameForm(request.POST)
	if form.is_valid():
	    name = form.cleaned_data['name']
	    r = AddStoreName(GetUserKod(request),name)
	    if r == 'OK':
		return HttpResponseRedirect('/storelist')


    form = StoreNameForm(None)

    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("store/storenew.html",c)






### --- Редактируем название ---
def	StoreEdit(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')


    try:
	store_id = request.GET['store_id']
	request.session['store_id'] = store_id
    except:
	pass
    try:
	store_id = request.session['store_id']
    except:
	return HttpResponseRedirect("/storelist")

    



    if request.method == 'POST':
	
	form = StoreNameForm(request.POST)
	if form.is_valid():
	    name = form.cleaned_data['name']
	    r = EditStoreName(store_id,GetUserKod(request),name)
	    if r == 'OK':
		return HttpResponseRedirect('/storelist')

    d = GetStoreName(store_id)

    form = StoreNameForm(None)
    form.fields['name'].initial = d[1]


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("store/storeedit.html",c)




