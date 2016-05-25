#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	AdminForm,EmailAddressForm
from	kis.lib.ithelpdesk	import	AddAdminUser,GetAdminList,DelAdminUser,GetAddressEmail,EditAddressEmail



### --- Настройки ---
def	ItOpt(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/opt.html")

    ### --- Сохранение закладки ----
    request.session['bookmark'] = 'itopt'

    if request.method == 'POST':
	form = AdminForm(request.POST)
	if form.is_valid():
	    admin = form.cleaned_data['admin']
	    AddAdminUser(admin)

    try:
	delete_admin = request.GET['delete_admin']
	DelAdminUser(delete_admin)
    except:
	pass


    form = AdminForm(None)

    ### --- Получение списка ---
    data = GetAdminList()
	
    c = RequestContext(request,{'form':form,'data':data})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/opt.html",c)






### --- Настройки Email ---
def	ItOptEmail(request):


    if CheckAccess(request,'3') != 'OK':
	return render_to_response("ithelpdesk/notaccess/opt.html")

    ### --- Сохранение закладки ----
    request.session['bookmark'] = 'itopt'

    if request.method == 'POST':
	form = EmailAddressForm(request.POST)
	if form.is_valid():
	    email = form.cleaned_data['email']
	    EditAddressEmail(email)


    form = EmailAddressForm(None)
    form.fields['email'].initial = GetAddressEmail()

	
    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/optemail.html",c)

