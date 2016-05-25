#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	forms			import	ChoiceTmcForm
from	kis.lib.store		import	GetStoreOneInRow,GetStoreModelData,GetStoreOneOutData



### --- Информация о вводе остатков и поступлениях ---
def	StoreOneInInfo(request):


    c = RequestContext(request,{})


    if request.method == 'GET':
	try:
	    row_id = request.GET['row_id']
	    row_data = GetStoreOneInRow(row_id)
	    modeldata = GetStoreModelData(row_data[6])
	    fieldlist = modeldata[2].split(';')
	    fielddata = row_data[7]
	    data = []
	    i = 0
	    for v in fielddata:
		data.append([fieldlist[i],v])
		i = i + 1
	    c = RequestContext(request,{'row_data':row_data,'modelname':modeldata[1],'data':data})

	except:
	    pass



    c.update(csrf(request))
    return render_to_response("store/ajaxonein.html",c)




### --- Информация о реализации ---
def	StoreOneOutInfo(request):


    c = RequestContext(request,{})


    if request.method == 'GET':
	try:
	    row_id = request.GET['row_id']
	    oneout = GetStoreOneOutData(row_id)
	    modeldata = GetStoreModelData(oneout[3])
	    fieldlist = modeldata[2].split(';')
	    fielddata = oneout[16]
	    data = []
	    i = 0
	    for v in fielddata:
		data.append([fieldlist[i],v])
		i = i + 1
	    c = RequestContext(request,{'data':data,'oneout':oneout})

	except:
	    pass



    c.update(csrf(request))
    return render_to_response("store/ajaxoneout.html",c)

