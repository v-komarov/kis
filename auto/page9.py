#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	PersonAutoForm
from	kis.lib.auto		import	GetPersonAutoList,AddAAutoPerson,GetAutoData,EditAAutoPerson




### --- Личные автомобили ---
def	Page9(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page9.html")



    data = GetPersonAutoList()

    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page9.html",c)




### --- Добавить ---
def	Add(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page9.html")


    if request.method == 'POST':
	
	form = PersonAutoForm(request.POST)
	if form.is_valid():
	    location = form.cleaned_data['location']
	    mark = form.cleaned_data['mark']
	    auto_type = form.cleaned_data['auto_type']
	    g_number = form.cleaned_data['g_number']
	    r = AddAAutoPerson(GetUserKod(request),location,mark,auto_type,g_number)
	    if r == 'OK':
		return HttpResponseRedirect("/page9auto")

    
    form = PersonAutoForm(None)
    form.fields['auto_type'].initial = '0'


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page9add.html",c)





### --- Редактировать ---
def	Edit(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page9.html")


    try:
	rec_id = request.GET['rec_id']
	request.session['rec_id'] = rec_id
    except:
	pass
    try:
	rec_id = request.session['rec_id']
    except:
	return HttpResponseRedirect("/page9auto")


    ### --- Получение данных записи ---
    d = GetAutoData(rec_id)
    

    if request.method == 'POST':
	
	form = PersonAutoForm(request.POST)
	if form.is_valid():
	    location = form.cleaned_data['location']
	    mark = form.cleaned_data['mark']
	    auto_type = form.cleaned_data['auto_type']
	    g_number = form.cleaned_data['g_number']
	    r = EditAAutoPerson(rec_id,location,mark,auto_type,g_number)
#	    if r == 'OK':
#		return HttpResponseRedirect("/page5auto")




    ### --- Получение данных записи ---
    d = GetAutoData(rec_id)

    form = PersonAutoForm(None)

    form.fields['location'].initial = d[1]
    form.fields['mark'].initial = d[2]
    form.fields['auto_type'].initial = d[15]
    form.fields['g_number'].initial = d[3]


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page9edit.html",c)


