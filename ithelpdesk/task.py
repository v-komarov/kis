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
from	forms			import	SearchForm,TaskEditForm,TaskNewForm,TaskCloneForm
from	kis.lib.ithelpdesk	import	GetItTaskList,GetItTaskData,NewItTaskStatus,GetItTaskStatusHistory,GetItDocData,GetItTaskMesUser,GetItDocData2,NewItTaskSelf,GetHistoryEmail
from	kis.lib.ithelpdesk_mail	import	EmailNewTask,EmailStatusTask



### --- Обработка заявок ---
def	ItTask(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")

    ### --- Сохранение закладки ----
    request.session['bookmark'] = 'ittask'

    ### --- Получение номера страницы ---
    try:
	page = request.GET['page']
	request.session['page'] = page
    except:
	pass
	
    try:
	page = request.session['page']
    except:
	page = '1'




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

    data = GetItTaskList(search)


    paginator = Paginator(data,50)
    try:
	data_page = paginator.page(page)
    except (EmptyPage, InvalidPage):
	data_page = paginator.page(paginator.num_pages)


	
    c = RequestContext(request,{'form':form,'data':data_page})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/task.html",c)








### --- Обработка заявок ---
def	ItTaskEdit(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")

    ## --- Номер заявки ---
    try:
	task_id = request.GET['task_id']
	request.session['task_id'] = task_id
    except:
	pass

    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/ittask")


    ip = request.META['REMOTE_ADDR']

    if request.method == 'POST':
	form = TaskEditForm(request.POST)
	if form.is_valid():
	    tema = form.cleaned_data['tema']
	    work = form.cleaned_data['work']
	    comment = form.cleaned_data['comment']
	    isp = form.cleaned_data['isp']
	    status = form.cleaned_data['status']
	    category = form.cleaned_data['category']
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
	    r = NewItTaskStatus(GetUserKod(request),task_id,tema,isp,comment,status,category,ip,file_name,file_ext,file_data,work)
	    if r.split(':')[0] == 'OK':
		EmailStatusTask(r.split(':')[1])

    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    form = TaskEditForm(None)
    form.fields['tema'].initial = d[6]
    form.fields['work'].initial = d[5]
    form.fields['isp'].initial = d[7]
    form.fields['status'].initial = d[13]
    form.fields['category'].initial = d[15]


    c = RequestContext(request,{'form':form,'d':d})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/taskedit.html",c)




### --- История статусов заявки ---
def	ItStatus(request):

    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")

    ## --- Номер заявки ---
    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/ittask")

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
    return render_to_response("ithelpdesk/itstatus.html",c)







### --- Сообщения пользователя ---
def	ItMesUser(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")


    ## --- Номер заявки ---
    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/ittask")

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
    return render_to_response("ithelpdesk/itmesuser.html",c)





### --- Создание новой заявки ---
def	ItTaskNew(request):

    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")


    ip = request.META['REMOTE_ADDR']

    if request.method == 'POST':
	form = TaskNewForm(request.POST)
	if form.is_valid():
	    tema = form.cleaned_data['tema']
	    task = form.cleaned_data['task']
	    work = form.cleaned_data['work']
	    isp = form.cleaned_data['isp']
	    category = form.cleaned_data['category']
	    user = form.cleaned_data['user']
	    r = NewItTaskSelf(tema,task,isp,category,work,user,ip)
	    if r.split(':')[0] == 'OK':
		EmailNewTask(r.split(':')[1])
		return HttpResponseRedirect("/ittask")
		


    form = TaskNewForm(None)
    form.fields['work'].initial = 0

    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/ittasknew.html",c)




### --- Клонирование заявки ---
def	ItTaskClone(request):

    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")

    ## --- Номер заявки ---
    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/ittask")

    ip = request.META['REMOTE_ADDR']

    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    form = TaskCloneForm(None)
    form.fields['tema'].initial = d[6]
    form.fields['task'].initial = d[17]
    form.fields['work'].initial = d[5]
    form.fields['isp'].initial = d[7]
    form.fields['category'].initial = d[15]


    if request.method == 'POST':
	form = TaskCloneForm(request.POST)
	if form.is_valid():
	    tema = form.cleaned_data['tema']
	    task = form.cleaned_data['task']
	    work = form.cleaned_data['work']
	    isp = form.cleaned_data['isp']
	    category = form.cleaned_data['category']
	    r = NewItTaskSelf(tema,task,isp,category,work,d[22],ip)
	    if r.split(':')[0] == 'OK':
		EmailNewTask(r.split(':')[1])
		return HttpResponseRedirect("/ittask")


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/ittaskclone.html",c)




### --- Информация по отправленным email уведомлениям заявки ---
def	ItTaskEmail(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/task.html")

    ## --- Номер заявки ---
    try:
	task_id = request.session['task_id']
    except:
	return HttpResponseRedirect("/ittask")

    ## --- Данные заявки ---
    d = GetItTaskData(task_id)

    data = GetHistoryEmail(task_id)

    c = RequestContext(request,{'d':d,'data':data})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/ittaskemail.html",c)
