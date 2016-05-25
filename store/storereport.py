#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	StoreNameForm
from	kis.lib.store		import	AddStoreName,GetStoreList,GetStoreName,EditStoreName



### --- Отчеты ---
def	StoreReport(request):


    try:
	if CheckAccess(request,'10') != 'OK':
	    return render_to_response("store/notaccess/storelist.html")
    except:
	return HttpResponseRedirect('/')


    data = GetStoreList()


    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("store/storereport.html",c)


