#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.store		import	GetOneData,GetStoreListUser,StoreOneIn
from	forms			import	OneInSimple,OneInNetDevice,OneInAdmin




### --- Поступление или ввод остатков ---
def	OneIn(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	one_id = request.GET['one_id']
	request.session['one_id'] = one_id
	type_one = request.GET['type_one']
	request.session['type_one'] = type_one
    except:
	pass
    try:
	one_id = request.session['one_id']
	type_one = request.session['type_one']
    except:
	return HttpResponseRedirect("/store")

    
    
    one = GetOneData(one_id)
    # --- Simple ---
    if one[5] == '0':

	if request.method == 'POST':
	    form = OneInSimple(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		store = form.cleaned_data['store']
		q = form.cleaned_data['q']
		okei = form.cleaned_data['okei']
		comment = form.cleaned_data['comment']
		r = StoreOneIn(GetUserKod(request),one_id,barcode,store,q,okei,type_one,'{'+comment+'}',one[5])
		if r == 'OK' and type_one == '0':
		    return HttpResponseRedirect("/storeone")
		elif r == 'OK' and type_one == '1':
		    return HttpResponseRedirect("/storerest")

	form = OneInSimple(None)
	storelist = GetStoreListUser(GetUserKod(request))
	storelist.insert(0,['',''])
	form.fields['store'].choices = storelist
	form.fields['store'].initial = ''
	form.fields['okei'].initial = '796'
	form.fields['q'].initial = 0.00

	c = RequestContext(request,{'one':one,'type':one[5],'form':form,'type_one':type_one})
	c.update(csrf(request))
	return render_to_response("store/oneinsimple.html",c)


    elif one[5] == '1':

	if request.method == 'POST':
	    form = OneInNetDevice(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		store = form.cleaned_data['store']
		q = form.cleaned_data['q']
		okei = form.cleaned_data['okei']
		comment = form.cleaned_data['comment']
		invnumber = form.cleaned_data['invnumber']
		sernumber = form.cleaned_data['sernumber']
		mac = form.cleaned_data['mac']
		hardware = form.cleaned_data['hardware']
		software = form.cleaned_data['software']
		options = "{'%s','%s','%s','%s','%s','%s'}" % (comment,invnumber,sernumber,mac,hardware,software)
		r = StoreOneIn(GetUserKod(request),one_id,barcode,store,q,okei,type_one,options,one[5])
		if r == 'OK' and type_one == '0':
		    return HttpResponseRedirect("/storeone")
		elif r == 'OK' and type_one == '1':
		    return HttpResponseRedirect("/storerest")

	form = OneInNetDevice(None)
	storelist = GetStoreListUser(GetUserKod(request))
	storelist.insert(0,['',''])
	form.fields['store'].choices = storelist
	form.fields['store'].initial = ''
	form.fields['okei'].initial = '796'
	form.fields['q'].initial = 0.00

	c = RequestContext(request,{'one':one,'type':one[5],'form':form,'type_one':type_one})
	c.update(csrf(request))
	return render_to_response("store/oneinnetdevice.html",c)


    elif one[5] == '2':

	if request.method == 'POST':
	    form = OneInAdmin(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		store = form.cleaned_data['store']
		q = form.cleaned_data['q']
		okei = form.cleaned_data['okei']
		comment = form.cleaned_data['comment']
		invnumber = form.cleaned_data['invnumber']
		sernumber = form.cleaned_data['sernumber']
		options = "{'%s','%s','%s'}" % (comment,invnumber,sernumber)
		r = StoreOneIn(GetUserKod(request),one_id,barcode,store,q,okei,type_one,options,one[5])
		if r == 'OK' and type_one == '0':
		    return HttpResponseRedirect("/storeone")
		elif r == 'OK' and type_one == '1':
		    return HttpResponseRedirect("/storerest")

	form = OneInAdmin(None)
	storelist = GetStoreListUser(GetUserKod(request))
	storelist.insert(0,['',''])
	form.fields['store'].choices = storelist
	form.fields['store'].initial = ''
	form.fields['okei'].initial = '796'
	form.fields['q'].initial = 0.00

	c = RequestContext(request,{'one':one,'type':one[5],'form':form,'type_one':type_one})
	c.update(csrf(request))
	return render_to_response("store/oneinadmin.html",c)

