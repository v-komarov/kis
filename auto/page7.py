#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	EmailGroupForm,EmailAuthorForm,NewSeasonFormS,NewSeasonFormW
from	kis.lib.auto		import	GetGroupEmail,AddGroupEmail,DelGroupEmail,GetAuthorEmail,SaveAuthorEmail,NewDateSeason,GetSeasonSW,DelSeasonSW



### --- Настройки группа email рассылки ---
def	Page7(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page7.html")

    if request.method == 'POST':
	form = EmailGroupForm(request.POST)
	if form.is_valid():
	    email = form.cleaned_data['groupemail']
	    AddGroupEmail(email)

    if request.method == 'GET':
	try:
	    delete_id = request.GET['delete_gemail']
	    DelGroupEmail(delete_id)
	except:
	    pass

    data = GetGroupEmail()

    form = EmailGroupForm(None)


    c = RequestContext(request,{'form':form,'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page7.html",c)







### --- Настройки обратный адрес ---
def	Page72(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page7.html")



    if request.method == 'POST':
	form = EmailAuthorForm(request.POST)
	if form.is_valid():
	    email = form.cleaned_data['authoremail']
	    SaveAuthorEmail(email)

    form = EmailAuthorForm()
    form.fields['authoremail'].initial = GetAuthorEmail()


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page72.html",c)






### --- Начало сезона ---
def	Page73(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page7.html")



    if request.method == 'POST':
	
	form_s = NewSeasonFormS(request.POST)
	if form_s.is_valid():
	    start_date = form_s.cleaned_data['start_date_s']
	    NewDateSeason(start_date,u'S')

	form_w = NewSeasonFormW(request.POST)
	if form_w.is_valid():
	    start_date = form_w.cleaned_data['start_date_w']
	    NewDateSeason(start_date,u'W')

    
    form_s = NewSeasonFormS(None)
    form_w = NewSeasonFormW(None)

    if request.method == 'GET':
	try:
	    delete_id = request.GET['delete_id']
	    DelSeasonSW(delete_id)
	except:
	    pass


    data_s = GetSeasonSW(u'S')
    data_w = GetSeasonSW(u'W')

    c = RequestContext(request,{'s':form_s,'w':form_w,'data_s':data_s,'data_w':data_w})
    c.update(csrf(request))
    return render_to_response("auto/page73.html",c)

