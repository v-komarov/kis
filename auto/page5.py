#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	AddAutoForm,AddAutoTrailerForm
from	kis.lib.auto		import	AddAAuto,GetAutoList,GetAutoData,EditAAuto,GetTrailerSW,GetAuStatusHistory,SetTrailerSW



### --- Автомобили ---
def	Page5(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page5.html")



    data = GetAutoList()

    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page5.html",c)






### --- Добавить ---
def	Add(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page5.html")



    if request.method == 'POST':
	
	form = AddAutoForm(request.POST)
	if form.is_valid():
	    location = form.cleaned_data['location']
	    mark = form.cleaned_data['mark']
	    auto_type = form.cleaned_data['auto_type']
	    g_number = form.cleaned_data['g_number']
	    status = form.cleaned_data['status']
	    auto_fuel = form.cleaned_data['auto_fuel']
	    fuel_s = form.cleaned_data['fuel_s']
	    fuel_w = form.cleaned_data['fuel_w']
	    r = AddAAuto(GetUserKod(request),location,mark,auto_type,g_number,status,auto_fuel,fuel_s,fuel_w)
	    if r == 'OK':
		return HttpResponseRedirect("/page5auto")


    
    form = AddAutoForm(None)

    form.fields['fuel_s'].initial = '0.00'
    form.fields['fuel_w'].initial = '0.00'



    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page5add.html",c)





### --- Редактировать ---
def	Edit(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page5.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page5auto")


    ### --- Получение данных записи ---
    d = GetAutoData(rec_id)
    

    if request.method == 'POST':
	
	form = AddAutoForm(request.POST)
	if form.is_valid():
	    location = form.cleaned_data['location']
	    mark = form.cleaned_data['mark']
	    auto_type = form.cleaned_data['auto_type']
	    g_number = form.cleaned_data['g_number']
	    status = form.cleaned_data['status']
	    auto_fuel = form.cleaned_data['auto_fuel']
	    fuel_s = form.cleaned_data['fuel_s']
	    fuel_w = form.cleaned_data['fuel_w']
	    r = EditAAuto(rec_id,location,mark,auto_type,g_number,status,auto_fuel,fuel_s,fuel_w,GetUserKod(request))
#	    if r == 'OK':
#		return HttpResponseRedirect("/page5auto")





    form = AddAutoForm(None)

    form.fields['location'].initial = d[1]
    form.fields['mark'].initial = d[2]
    form.fields['auto_type'].initial = d[15]
    form.fields['g_number'].initial = d[3]
    form.fields['status'].initial = d[16]
    form.fields['auto_fuel'].initial = d[14]
    form.fields['fuel_s'].initial = d[6]
    form.fields['fuel_w'].initial = d[7]



    ### --- Получение данных по расходу топлива с прицепом ---
    data = GetTrailerSW(rec_id)

    ### --- Получение данных записи ---
    d = GetAutoData(rec_id)


    c = RequestContext(request,{'form':form,'data':data,'d':d})
    c.update(csrf(request))
    return render_to_response("auto/page5edit.html",c)






### --- История статусов ---
def	StatusHistory(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page5.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page5auto")


    ### --- Получение данных записи ---
    d = GetAutoData(rec_id)

    ### --- Получение данных по истории статусов ---
    data = GetAuStatusHistory(rec_id)

    c = RequestContext(request,{'d':d,'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page5editstatus.html",c)




### --- Расход топлива с прицепом ---
def	Trailer(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page5.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page5auto")

    if request.method == 'POST':
	form = AddAutoTrailerForm(request.POST)
	if form.is_valid():
	    fuel_s = form.cleaned_data['fuel_s']
	    fuel_w = form.cleaned_data['fuel_w']
	    SetTrailerSW(rec_id,fuel_s,fuel_w)


    data = GetTrailerSW(rec_id)

    form = AddAutoTrailerForm(None)
    form.fields['fuel_s'].initial = data[0]
    form.fields['fuel_w'].initial = data[1]

    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page5edittrailer.html",c)


