#coding:utf-8
import	os.path
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	cStringIO	import	StringIO

from	kis.lib.auto_print	import	PrintForm




### --- Печатная форма заявки ---
def	TaskPrint(request):

	#try:
	task_id = request.GET['task_id']

	response = HttpResponse(content_type='application/pdf')
	response['Content-Disposition'] = 'attachment; filename="auto.pdf"'
	buff = StringIO()
	result = PrintForm(buff,task_id)
	response.write(result.getvalue())
	buff.close()
	return response

	#except:
	#    pass

