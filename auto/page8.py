#coding:utf-8
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	ReportForm
from	kis.lib.auto_report	import	Report_0



### --- Отчеты ---
def	Page8(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page8.html")

    if request.method == 'POST':
	
	form = ReportForm(request.POST)
	if form.is_valid():
	    start_date = form.cleaned_data['start_date']
	    end_date = form.cleaned_data['end_date']
	    report = form.cleaned_data['report']

	    response = HttpResponse(mimetype="application/ms-excel")
	    response['Content-Disposition'] = 'attachment; filename=report.xls'
	    if report == '0':
		return Report_0(response,start_date,end_date)

		

    form = ReportForm(None)


    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page8.html",c)







