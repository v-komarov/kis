#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod





### --- ItHelpdesk ---
def	ItHelpDesk(request):


    try:
	user_kod = GetUserKod(request)
    except:
	return HttpResponseRedirect('/')



    ### --- Востановление закладки ----
    try:
	bookmark = request.session['bookmark']
    except:
	bookmark = 'itmy'

    if bookmark == 'itmy':
	return HttpResponseRedirect("/itmy")
    elif bookmark == 'ittask':
	return HttpResponseRedirect("/ittask")
    elif bookmark == 'itreport':
	return HttpResponseRedirect("/itreport")
    elif bookmark == 'itopt':
	return HttpResponseRedirect("/itopt")
    else:
	return render_to_response("notaccess.html")
	
