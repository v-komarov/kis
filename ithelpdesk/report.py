#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	ReportForm
from	kis.lib.ithelpdesk	import	GetDataReport
from	kis.lib.ithelpdesk_report	import	ItReportFile



### --- Отчеты ---
def	ItReport(request):


    if CheckAccess(request,'17') != 'OK':
	return render_to_response("ithelpdesk/notaccess/report.html")

    ### --- Сохранение закладки ----
    request.session['bookmark'] = 'itreport'
    if request.method == 'POST':
	form = ReportForm(request.POST)
	if form.is_valid():
	    start_date = form.cleaned_data['start_date']
	    end_date = form.cleaned_data['end_date']
	    request.session['start_date'] = start_date
	    request.session['end_date'] = end_date

    try:
	start_date = request.session['start_date']
	end_date = request.session['end_date']
    except:
	start_date = datetime.date.today()
	end_date = datetime.date.today()



    form = ReportForm(None)

    form.fields['start_date'].initial = start_date
    form.fields['end_date'].initial = end_date

    data = GetDataReport(start_date,end_date)


    ### --- вывод в excel файл ---
    try:
	report_excel = request.GET['report-excel']
	response = HttpResponse(mimetype="application/ms-excel")
	response['Content-Disposition'] = 'attachment; filename=report.xls'
	return ItReportFile(start_date,end_date,response,data)
    except:
	pass


    c = RequestContext(request,{'form':form,'data':data})
    c.update(csrf(request))
    return render_to_response("ithelpdesk/report.html",c)
