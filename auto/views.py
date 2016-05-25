#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.auto		import	GetANewTaskTrip,GetANewTaskTripData,GetAStatusChoiceList,EditATaskTrip,GetAStatusHistory,GetHistoryEmail
from	kis.lib.auto_mail	import	Email2Ruk,EmailStatusInfo
from	forms			import	SearchForm,EditTaskForm,TaskChiefForm


### --- Список ---
def	List(request):


    try:
	if CheckAccess(request,'7') != 'OK':
	    return render_to_response("notaccess.html")
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




    if request.method == 'POST':
	
	form = SearchForm(request.POST)
	if form.is_valid():
	    search = form.cleaned_data['search']
	    request.session['search'] = search
    else:
	form = SearchForm()

    try:
	search = request.session['search']
    except:
	search = ''
    

    form.fields['search'].initial = search

    data = GetANewTaskTrip(search)
    
    paginator = Paginator(data,50)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)



    c = RequestContext(request,{'form':form,'data':data_page})
    c.update(csrf(request))
    return render_to_response("auto/list.html",c)






### --- Редактировать ---
def	Edit(request):


    if CheckAccess(request,'7') != 'OK':
	return render_to_response("notaccess.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page4auto")

    

    if request.method == 'POST':
	
	form = EditTaskForm(request.POST)
	if form.is_valid():
	    start_date = form.cleaned_data['start_date']
	    start_time = form.cleaned_data['start_time']
	    end_date = form.cleaned_data['end_date']
	    end_time = form.cleaned_data['end_time']
	    route = form.cleaned_data['route']
	    place = form.cleaned_data['place']
	    auto = form.cleaned_data['auto']
	    target = form.cleaned_data['target']
	    start_datetime = u"%s %s:00" % (start_date,start_time)
	    end_datetime = u"%s %s:00" % (end_date,end_time)
	    status = form.cleaned_data['status']
	    comment = form.cleaned_data['comment']

	    r = EditATaskTrip(rec_id,GetUserKod(request),start_datetime,end_datetime,route,place,auto,target,status,comment)
	    if r == 'OK':
		EmailStatusInfo(rec_id)

    form = EditTaskForm(None)

    ### --- Получение данных записи ---
    d = GetANewTaskTripData(rec_id)
    choice_status = GetAStatusChoiceList(d[8])

    form.fields['status'].choices = choice_status
    form.fields['status'].initial = d[8]

    (year,month,day) = d[4].split('-')
    form.fields['start_date'].initial = datetime.date(int(year),int(month),int(day))

    (year,month,day) = d[28].split('-')
    form.fields['end_date'].initial = datetime.date(int(year),int(month),int(day))


    form.fields['start_time'].initial = d[3]
    form.fields['end_time'].initial = d[27]
#    form.fields['time'].initial = d[5]
    form.fields['route'].initial = d[6]
    form.fields['place'].initial = d[7]
    form.fields['auto'].initial = d[10]
    form.fields['target'].initial = d[29]


#    if d[14] == 'Y':
#	form.fields['trailer'].initial = True
#    else:
#	form.fields['trailer'].initial = False
	


    c = RequestContext(request,{'form':form,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page1edit.html",c)






### --- история статусов ---
def	StatusHistory(request):


    if CheckAccess(request,'7') != 'OK':
	return render_to_response("notaccess.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/auto")

    ### --- Получение данных записи ---
    d = GetANewTaskTripData(rec_id)

    ### --- Получение истории статусов ---
    data = GetAStatusHistory(rec_id)

    c = RequestContext(request,{'data':data,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page1status.html",c)




### --- Отправка запроса подписи заказа ---
def	Chief(request):


    if CheckAccess(request,'7') != 'OK':
	return render_to_response("notaccess.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/auto")

    if request.method == 'POST':
	
	form = TaskChiefForm(request.POST)
	if form.is_valid():
	    chief = form.cleaned_data['chief']
	    Email2Ruk(chief,rec_id)
    form = TaskChiefForm(None)

    ### --- Получение данных записи ---
    d = GetANewTaskTripData(rec_id)


    c = RequestContext(request,{'form':form,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page1chief.html",c)







### --- История email уведомлений ---
def	EmailHistory(request):


    if CheckAccess(request,'7') != 'OK':
	return render_to_response("notaccess.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/auto")


    ### --- Получение данных записи ---
    d = GetANewTaskTripData(rec_id)

    data = GetHistoryEmail(rec_id)

    c = RequestContext(request,{'data':data,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page1email.html",c)



