#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	SearchForm,EditTaskForm2
from	kis.lib.auto		import	GetATaskTrip,GetATripTaskData,GetAStatusChoiceList,EditATaskTrip2,GetAStatusHistory,GetHistoryEmail
from	kis.lib.auto_mail	import	EmailStatusInfo




### --- Выезды по заявкам ---
def	Page3(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page3.html")

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

    try:
	search = request.session['search']
    except:
	search = ''



    data = GetATaskTrip(search)
    paginator = Paginator(data,50)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)


    form = SearchForm(None)
    form.fields['search'].initial = search


    c = RequestContext(request,{'data':data_page,'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page3.html",c)








### --- Редактировать ---
def	Edit(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page3.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page3auto")

    

    if request.method == 'POST':
	
	form = EditTaskForm2(request.POST)
	if form.is_valid():
	    start_date = form.cleaned_data['start_date']
	    start_time = form.cleaned_data['start_time']
	    end_date = form.cleaned_data['end_date']
	    end_time = form.cleaned_data['end_time']
	    time = form.cleaned_data['time']
	    route = form.cleaned_data['route']
	    place = form.cleaned_data['place']
	    driver = form.cleaned_data['driver']
	    auto = form.cleaned_data['auto']
	    target = form.cleaned_data['target']
	    traveler = form.cleaned_data['traveler']
	    trailer = form.cleaned_data['trailer']
	    chief = form.cleaned_data['chief']
	    speedo1 = form.cleaned_data['speedo1']
	    speedo2 = form.cleaned_data['speedo2']
	    fuel = form.cleaned_data['fuel']
	    status = form.cleaned_data['status']
	    comment = form.cleaned_data['comment']
	    if trailer == 'True':
		trailer = 'Y'
	    else:
		trailer = 'N'
	    start_datetime = u"%s %s:00" % (start_date,start_time)
	    end_datetime = u"%s %s:00" % (end_date,end_time)

	    r = EditATaskTrip2(rec_id,GetUserKod(request),start_datetime,end_datetime,time,route,place,auto,target,traveler,trailer,driver,speedo1,speedo2,fuel,status,comment)
	    if r == 'OK':
		EmailStatusInfo(rec_id)

    form = EditTaskForm2(None)

    ### --- Получение данных записи ---
    
    d = GetATripTaskData(rec_id)
    choice_status = GetAStatusChoiceList(d[17])

    form.fields['status'].choices = choice_status
    form.fields['status'].initial = d[17]

    (year,month,day) = d[2].split('-')
    form.fields['start_date'].initial = datetime.date(int(year),int(month),int(day))
    (year,month,day) = d[40].split('-')
    form.fields['end_date'].initial = datetime.date(int(year),int(month),int(day))

    form.fields['start_time'].initial = d[4]
    form.fields['end_time'].initial = d[39]
    form.fields['time'].initial = d[5]
    form.fields['route'].initial = d[7]
    form.fields['place'].initial = d[8]
    form.fields['auto'].initial = d[35]
    form.fields['driver'].initial = d[10]
    form.fields['chief'].initial = d[36]
    form.fields['chief'].widget.attrs['disabled'] = True
    form.fields['speedo1'].initial = d[18]
    form.fields['speedo2'].initial = d[19]
    form.fields['fuel'].initial = d[20]

    form.fields['target'].initial = d[41]
    form.fields['traveler'].initial = d[42]

    if d[9] == 'Y':
	form.fields['trailer'].initial = True
    else:
	form.fields['trailer'].initial = False
	


    c = RequestContext(request,{'form':form,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page3edit.html",c)








### --- история статусов ---
def	StatusHistory(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page3.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page3auto")

    ### --- Получение данных записи ---
    d = GetATripTaskData(rec_id)

    ### --- Получение истории статусов ---
    data = GetAStatusHistory(rec_id)

    c = RequestContext(request,{'data':data,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page3edit2.html",c)





### --- История email уведомлений ---
def	EmailHistory(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page3.html")


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
    d = GetATripTaskData(rec_id)

    data = GetHistoryEmail(rec_id)

    c = RequestContext(request,{'data':data,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page3edit4.html",c)


