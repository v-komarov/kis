#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.store		import	GetOneData,SaveModelData,GetStoreRest,GetStoreOneIn,StoreOneInCancel,GetStoreProcess,GetStoreReserve,GetStoreReserveSum,DeleteReserve,GetStoreOneOut,StoreOneOutCancel
from	forms			import	ModelDataForm



### --- Поступления ---
def	One(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
    except:
	pass
    try:
	one_id = request.session['one_id']
    except:
	return HttpResponseRedirect("/store")


    if request.method == 'GET':
	
	try:
	    cancel_one = request.GET['cancel_one']
	    StoreOneInCancel(GetUserKod(request),cancel_one)
	except:
	    pass

    
    ### --- Остатки по складам ---
    rest = GetStoreRest(one_id)
    ### --- Резервы по складам ---
    reserve = GetStoreReserveSum(one_id)

    if request.method == 'POST':
	
	form = ModelDataForm(request.POST)
	if form.is_valid():
	    modeldata = form.cleaned_data['modeldata']
	    SaveModelData(one_id,modeldata)




    one = GetOneData(one_id)

    onein = GetStoreOneIn(one_id,0)

    form = ModelDataForm(None)
    form.fields['modeldata'].initial = one[5]


    c = RequestContext(request,{'one':one,'form':form,'rest':rest,'onein':onein,'reserve':reserve})
    c.update(csrf(request))
    return render_to_response("store/one.html",c)






### --- Ввод остатков ---
def	OneRest(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
    except:
	pass
    try:
	one_id = request.session['one_id']
    except:
	return HttpResponseRedirect("/store")

    
    ### --- Остатки по складам ---
    rest = GetStoreRest(one_id)
    ### --- Резервы по складам ---
    reserve = GetStoreReserveSum(one_id)


    if request.method == 'POST':
	
	form = ModelDataForm(request.POST)
	if form.is_valid():
	    modeldata = form.cleaned_data['modeldata']
	    SaveModelData(one_id,modeldata)


    one = GetOneData(one_id)

    onein = GetStoreOneIn(one_id,1)

    form = ModelDataForm(None)
    form.fields['modeldata'].initial = one[5]


    c = RequestContext(request,{'one':one,'form':form,'rest':rest,'onein':onein,'reserve':reserve})
    c.update(csrf(request))
    return render_to_response("store/onerest.html",c)







### --- Резерв ---
def	OneReserve(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
    except:
	pass
    try:
	one_id = request.session['one_id']
    except:
	return HttpResponseRedirect("/store")


    if request.method == 'GET':
	try:
	    reserve_id = request.GET['delete_reserve']
	    DeleteReserve(reserve_id)
	except:
	    pass


    ### --- Остатки по складам ---
    rest = GetStoreRest(one_id)
    ### --- Резервы по складам ---
    reserve = GetStoreReserveSum(one_id)

    one = GetOneData(one_id)

    data = GetStoreReserve(one_id)

    c = RequestContext(request,{'one':one,'rest':rest,'hidden':True,'data':data,'reserve':reserve})
    c.update(csrf(request))
    return render_to_response("store/onereserve.html",c)













### --- Реализация ---
def	OneOut(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
    except:
	pass
    try:
	one_id = request.session['one_id']
    except:
	return HttpResponseRedirect("/store")


    if request.method == 'GET':
	try:
	    cancel_one = request.GET['cancel_one']
	    StoreOneOutCancel(GetUserKod(request),cancel_one)
	except:
	    pass


    ### --- Остатки по складам ---
    rest = GetStoreRest(one_id)
    ### --- Резервы по складам ---
    reserve = GetStoreReserveSum(one_id)

    one = GetOneData(one_id)

    data = GetStoreOneOut(one_id)

    c = RequestContext(request,{'one':one,'rest':rest,'hidden':True,'data':data,'reserve':reserve})
    c.update(csrf(request))
    return render_to_response("store/oneout.html",c)













### --- Движения ---
def	OneProcess(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
    except:
	pass
    try:
	one_id = request.session['one_id']
    except:
	return HttpResponseRedirect("/store")

    ### --- Остатки по складам ---
    rest = GetStoreRest(one_id)
    ### --- Резервы по складам ---
    reserve = GetStoreReserveSum(one_id)

    one = GetOneData(one_id)

    oneprocess = GetStoreProcess(one_id)


    c = RequestContext(request,{'one':one,'rest':rest,'hidden':True,'oneprocess':oneprocess,'reserve':reserve})
    c.update(csrf(request))
    return render_to_response("store/oneprocess.html",c)




