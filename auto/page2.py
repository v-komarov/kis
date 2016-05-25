#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	NewTaskForm
from	kis.lib.auto		import	AddATaskTrip


### --- Новый заказ ---
def	Page2(request):


    if CheckAccess(request,'7') != 'OK':
	return render_to_response("notaccess.html")



    if request.method == 'POST':
	
	form = NewTaskForm(request.POST)
	if form.is_valid():
	    start_date = form.cleaned_data['start_date']
	    start_time = form.cleaned_data['start_time']
	    end_date = form.cleaned_data['end_date']
	    end_time = form.cleaned_data['end_time']
	    route = form.cleaned_data['route']
	    place = form.cleaned_data['place']
	    auto = form.cleaned_data['auto']
	    target = form.cleaned_data['target']

#	    trailer = form.cleaned_data['trailer']
#	    if trailer == 'True':
#		trailer = 'Y'
#	    else:
#		trailer = 'N'
	    start_datetime = u"%s %s:00" % (start_date,start_time)
	    end_datetime = u"%s %s:00" % (end_date,end_time)

	    r = AddATaskTrip(GetUserKod(request),start_datetime,end_datetime,route,place,auto,target)
	    if r == 'OK':
		return HttpResponseRedirect("/auto")
    else:
	form = NewTaskForm()



    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page2.html",c)

