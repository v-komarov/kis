#coding:utf-8
import	os.path
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	GuideForm
from	kis.lib.auto		import	LoadGuide,GetGuideList,GetDoc,DeleteGuide




### --- Инструкции ---
def	List(request):


    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page10.html")

    ### --- Отображение ---
    if request.method == 'GET':
	try:
	    doc_id = request.GET['doc_id']
	    f = GetDoc(doc_id)
	    response = HttpResponse(content_type='application/%s' % f[0][-1:])
	    attach = u'attachment; filename=\"%s\"' % (f[2])
	    response['Content-Disposition'] = attach.encode('utf-8')
	    response.write(f[1])
	    return response
	except:
	    pass


    ### --- Удаление инструкции ---
    if request.method == 'GET':
	try:
	    delete_id = request.GET['delete_id']
	    DeleteGuide(delete_id)
	except:
	    pass


    data = GetGuideList()

    c = RequestContext(request,{'data':data})
    c.update(csrf(request))
    return render_to_response("auto/page10.html",c)




### --- Добавление ---
def	Add(request):

    if CheckAccess(request,'8') != 'OK':
	return render_to_response("auto/notaccess/page10.html")


    if request.method == 'POST':
	form = GuideForm(request.POST)
	if form.is_valid():
	    try:
		guide = form.cleaned_data['guide']
		file_name = request.FILES['file_load'].name
		file_data = request.FILES['file_load'].read()
		file_name = file_name.split('\\')[-1]
		(path,ext) = os.path.splitext(file_name)
		file_name = file_name.replace(' ','_')
		LoadGuide(GetUserKod(request),guide,file_name,ext,file_data)
		return HttpResponseRedirect("/page10auto")
	    except:
		pass

    form = GuideForm(None)

    c = RequestContext(request,{'form':form})
    c.update(csrf(request))
    return render_to_response("auto/page10add.html",c)

