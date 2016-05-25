#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	AddDriverForm
from	kis.lib.auto		import	AddADriver,GetDriverList,DelADriver



### --- Водители ---
def	Page6(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page6.html")



    if request.method == 'POST':
	
	form = AddDriverForm(request.POST)
	if form.is_valid():
	    location = form.cleaned_data['location']
	    driver = form.cleaned_data['driver']
	    license = form.cleaned_data['license']
	    category = form.cleaned_data['category']
	    (driver_kod,driver_name) = driver.split('#')
	    AddADriver(GetUserKod(request),driver_kod,location,driver_name,license,category)
    else:
	form = AddDriverForm()

    if request.method == 'GET':
	try:
	    delete_id = request.GET['delete_id']
	    DelADriver(delete_id)
	except:
	    pass


    data = GetDriverList()

    c = RequestContext(request,{'form':form,'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page6.html",c)

