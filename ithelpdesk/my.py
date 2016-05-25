#coding:utf-8
import	datetime
import	os.path
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	SearchForm,MessNewUserForm,TaskNewUserForm
from	kis.lib.ithelpdesk	import	GetItTaskUser,GetItDocData,GetItTaskData,GetItTaskStatusHistory,GetItDocData2,GetItTaskMesUser,AddItDocUser,NewItTaskUser
from	kis.lib.ithelpdesk_mail	import	EmailNewTask,EmailMessTask



### --- Подача и отслеживание заявок пользователем ---
def	ItMy(request):

    ### --- Кто пользователь ---
    try:
	user_kod = GetUserKod(request)
    except:
	return HttpResponseRedirect("/")
	

    ### --- Сохранение закладки ----
    request.session['bookmark'] = 'itmy'



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

    data = GetItTaskUser(search,user_kod)


    paginator = Paginator(data,20)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)





	
    c = RequestContext(request,{'data':data_page,'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/my.html",c)








### --- Список статусов по заявке ---
def	ItTaskUser(request):


    ## --- Номер заявки ---
    try:
	task_id = request.GET['task_id']
	request.session['task_id'] = task_id
    except:
	pass

    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/")


    ### --- Отображение файла ---
    try:
	file_id = request.GET['file_data']
	f = GetItDocData(file_id)
	response = HttpResponse(content_type='application/%s' % f[3][-1:])
	attach = u'attachment; filename=\"%s\"' % (f[4])
	response['Content-Disposition'] = attach.encode('utf-8')
	response.write(f[9])
	return response

    except:
	pass

    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    ## --- История статусов ---
    data = GetItTaskStatusHistory(task_id)



    c = RequestContext(request,{'d':d,'data':data})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/ittaskuser.html",c)




### --- Список сообщений по заявке ---
def	ItMessUser(request):


    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/")

    ### --- Отображение файла ---
    try:
	file_id = request.GET['file_data']
	f = GetItDocData2(file_id)
	response = HttpResponse(content_type='application/%s' % f[3][-1:])
	attach = u'attachment; filename=\"%s\"' % (f[4])
	response['Content-Disposition'] = attach.encode('utf-8')
	response.write(f[9])
	return response

    except:
	pass



    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    ## --- Комментарии пользователя ---
    data = GetItTaskMesUser(task_id)



    c = RequestContext(request,{'d':d,'data':data})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/itmessuser.html",c)




### --- Создание нового сообщения (и загрузка файла) ---
def	ItNewMess(request):

    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/")


    ip = request.META['REMOTE_ADDR']

    if request.method == 'POST':
	form = MessNewUserForm(request.POST)
	if form.is_valid():
	    mess = form.cleaned_data['mess']
	    try:
		file_name = request.FILES['file_load'].name
		file_data = request.FILES['file_load'].read()
		file_name = file_name.split('\\')[-1]
		(path,ext) = os.path.splitext(file_name)
		file_name = file_name.replace(' ','_')
		file_ext = ext
	    except:
		file_name = ''
		file_ext = ''
		file_data = ''
	    r = AddItDocUser(task_id,file_name,mess,file_ext,ip,file_data)
	    if r.split(':')[0] == 'OK':
		EmailMessTask(r.split(':')[1])
		return HttpResponseRedirect("/itmessuser")



    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    form = MessNewUserForm(None)

    c = RequestContext(request,{'d':d,'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/itnewmess.html",c)







### --- Новая заявка ---
def	ItNewTaskUser(request):


    ip = request.META['REMOTE_ADDR']


    if request.method == 'POST':
	form = TaskNewUserForm(request.POST)
	if form.is_valid():
	    task = form.cleaned_data['task']
	    r = NewItTaskUser(GetUserKod(request),task,ip)
	    if r.split(':')[0] == 'OK':
		EmailNewTask(r.split(':')[1])
		return HttpResponseRedirect("/itmy")



    form = TaskNewUserForm(None)


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/newtaskuser.html",c)
