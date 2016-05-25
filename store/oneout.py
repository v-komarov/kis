#coding:utf-8
import	datetime
from	django.http	import	HttpResponse
from	django.http	import	HttpResponseRedirect
from	django.template	import	Context, loader, RequestContext
from	django.core.context_processors	import	csrf
from	django.shortcuts	import	render_to_response

from	django.core.paginator	import	Paginator, InvalidPage, EmptyPage

from	kis.lib.userdata	import	CheckAccess,GetUserKod
from	kis.lib.store		import	GetStoreReserveData,StoreOneOut
from	forms			import	OneOutSimple,OneOutNetDevice,OneOutAdmin






### --- Новая Реализация ---
def	OneOutNew(request):


    try:
	if CheckAccess(request,'9') != 'OK':
	    return render_to_response("store/notaccess/store.html")
    except:
	return HttpResponseRedirect('/')



    try:
	reserve_id = request.GET['reserve_id']
	request.session['reserve_id'] = reserve_id
    except:
	pass
    try:
	reserve_id = request.session['reserve_id']
    except:
	return HttpResponseRedirect("/store")

    r = GetStoreReserveData(reserve_id)
    
    # --- Simple ---
    if r[15] == 0:

	if request.method == 'POST':
	    form = OneOutSimple(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		q = form.cleaned_data['q']
		comment = form.cleaned_data['comment']
		options = "{'%s'}" % (comment)
		r = StoreOneOut(GetUserKod(request),reserve_id,barcode,q,options)
		if r == 'OK':
		    return HttpResponseRedirect("/storereserve")


	form = OneOutSimple(None)
	form.fields['q'].initial = r[6]

	c = RequestContext(request,{'r':r,'form':form})
	c.update(csrf(request))
	return render_to_response("store/oneoutsimple.html",c)


    elif r[15] == 1:

	if request.method == 'POST':
	    form = OneOutNetDevice(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		q = form.cleaned_data['q']
		comment = form.cleaned_data['comment']
		invnumber = form.cleaned_data['invnumber']
		sernumber = form.cleaned_data['sernumber']
		mac = form.cleaned_data['mac']
		hardware = form.cleaned_data['hardware']
		software = form.cleaned_data['software']
		options = "{'%s','%s','%s','%s','%s','%s'}" % (comment,invnumber,sernumber,mac,hardware,software)
		r = StoreOneOut(GetUserKod(request),reserve_id,barcode,q,options)
		if r == 'OK':
		    return HttpResponseRedirect("/storereserve")
		    

	form = OneOutNetDevice(None)
	form.fields['q'].initial = r[6]

	c = RequestContext(request,{'r':r,'form':form})
	c.update(csrf(request))
	return render_to_response("store/oneoutnetdevice.html",c)


    elif r[15] == 2:

	if request.method == 'POST':
	    form = OneOutAdmin(request.POST)
	    if form.is_valid():
		barcode = form.cleaned_data['barcode']
		q = form.cleaned_data['q']
		comment = form.cleaned_data['comment']
		invnumber = form.cleaned_data['invnumber']
		sernumber = form.cleaned_data['sernumber']
		options = "{'%s','%s','%s'}" % (comment,invnumber,sernumber)
		r = StoreOneOut(GetUserKod(request),reserve_id,barcode,q,options)
		if r == 'OK':
		    return HttpResponseRedirect("/storereserve")

	form = OneOutAdmin(None)
	form.fields['q'].initial = r[6]

	c = RequestContext(request,{'r':r,'form':form})
	c.update(csrf(request))
	return render_to_response("store/oneoutadmin.html",c)

