#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	StorePersonForm
from	kis.lib.store		import	AddStorePerson,GetStorePerson,DelStorePerson



### --- Список кладовщиков ---
def	StorePersonList(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')


    if request.method == 'GET':
	try:
	    delete_id = request.GET['delete_id']
	    DelStorePerson(delete_id)
	except:
	    pass


    data = GetStorePerson()


    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("store/storepersonlist.html",c)




### --- Создать кладовщика ---
def	StorePersonNew(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')

    if request.method == 'POST':
	
	form = StorePersonForm(request.POST)
	if form.is_valid():
	    store = form.cleaned_data['store']
	    person = form.cleaned_data['person']
	    r = AddStorePerson(GetUserKod(request),store,person)
	    if r == 'OK':
		return HttpResponseRedirect('/storeperson')


    form = StorePersonForm(None)
    form.fields['store'].initial = '0'
    form.fields['person'].initial = ''


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("store/storepersonnew.html",c)




