from django.conf.urls import patterns, include, url
from	django.contrib.staticfiles.urls	import	staticfiles_urlpatterns
from	django.conf	import	settings


# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()

urlpatterns = patterns('',
    # Examples:
    # url(r'^$', 'kis.views.home', name='home'),
    # url(r'^kis/', include('kis.foo.urls')),

    url(r'^$', 'start.views.Home', name='Home'),
    url(r'^exit/$', 'start.views.Exit', name='Exit'),


    url(r'^tmc/$', 'tmc.views.ListTmc', name='ListTmc'),
    url(r'^tmcnew/$', 'tmc.views.TmcNew', name='TmcNew'),
    url(r'^tmcedit/$', 'tmc.views.TmcEdit', name='TmcEdit'),
    url(r'^tmcdata/$', 'tmc.tmcdata1.TmcData1', name='TmcData1'),
    url(r'^tmcdata2/$', 'tmc.tmcdata2.TmcData2', name='TmcData2'),
    url(r'^tmcdata3/$', 'tmc.tmcdata3.TmcData3', name='TmcData3'),
    url(r'^tmcdata4/$', 'tmc.tmcdata4.TmcData4', name='TmcData4'),
    url(r'^tmcdata5/$', 'tmc.tmcdata5.TmcData5', name='TmcData5'),
    url(r'^tmcdata6/$', 'tmc.tmcdata6.TmcData6', name='TmcData6'),
    url(r'^tmcdata7/$', 'tmc.tmcdata7.TmcData7', name='TmcData7'),
    url(r'^tmcnewspec/$', 'tmc.tmcdata1.NewSpec', name='NewSpec'),
    url(r'^tmcspecedit/$', 'tmc.tmcdata1.EditSpec', name='EditSpec'),

    url(r'^tmcopt/$', 'tmc.opt.Finance', name='Finance'),
    url(r'^tmcopt2/$', 'tmc.opt.Logistic', name='Logistic'),

    url(r'^tmcorderlist/$', 'tmc.internalorder.List', name='List'),
    url(r'^tmcordernew/$', 'tmc.internalorder.New', name='New'),
    url(r'^tmcorderspec/$', 'tmc.internalorder.Spec', name='Spec'),
    url(r'^tmcorderprint/$', 'tmc.internalorder.OrderPrint', name='OrderPrint'),


    url(r'^contract/$', 'contract.views.List', name='List'),
    url(r'^newcontract/$', 'contract.views.New', name='New'),
    url(r'^contractopt/$', 'contract.views.Opt', name='Opt'),
    url(r'^editcontract/$', 'contract.views.EditPage1', name='EditPage1'),
    url(r'^page2contract/$', 'contract.page2.Page2', name='Page2'),
    url(r'^page3contract/$', 'contract.page3.Page3', name='Page3'),
    url(r'^page4contract/$', 'contract.page4.Page4', name='Page4'),
    url(r'^page5contract/$', 'contract.page5.Page5', name='Page5'),
    url(r'^page6contract/$', 'contract.page6.Page6', name='Page6'),
    url(r'^page7contract/$', 'contract.page7.Page7', name='Page7'),
    url(r'^page8contract/$', 'contract.page8.Page8', name='Page8'),


    url(r'^auto/$', 'auto.views.List', name='List'),
    url(r'^page1edit/$', 'auto.views.Edit', name='Edit'),
    url(r'^page1status/$', 'auto.views.StatusHistory', name='StatusHistory'),
    url(r'^page1chief/$', 'auto.views.Chief', name='Chief'),
    url(r'^page1email/$', 'auto.views.EmailHistory', name='EmailHistory'),
    url(r'^page2auto/$', 'auto.page2.Page2', name='Page2'),
    url(r'^page3auto/$', 'auto.page3.Page3', name='Page3'),
    url(r'^page3autoedit/$', 'auto.page3.Edit', name='Edit'),
    url(r'^page3auto2/$', 'auto.page3.StatusHistory', name='StatusHistory'),
    url(r'^page3auto3/$', 'auto.page3.PrintData', name='PrintData'),
    url(r'^page3auto4/$', 'auto.page3.EmailHistory', name='EmailHistory'),
    url(r'^page4auto/$', 'auto.page4.Page4', name='Page4'),
    url(r'^page4autoadd/$', 'auto.page4.Add', name='Add'),
    url(r'^page4autoedit/$', 'auto.page4.Edit', name='Edit'),
    url(r'^page4auto2$', 'auto.page4.StatusHistory',name='StatusHistory'),
    url(r'^page4auto3$', 'auto.page4.PrintData',name='PrintData'),
    url(r'^page5auto/$', 'auto.page5.Page5', name='Page5'),
    url(r'^page5autoadd/$', 'auto.page5.Add', name='Add'),
    url(r'^page5autoedit/$', 'auto.page5.Edit', name='Edit'),
    url(r'^page5autoeditstatus/$', 'auto.page5.StatusHistory', name='StatusHistory'),
    url(r'^page5autoedittrailer/$', 'auto.page5.Trailer', name='Trailer'),
    url(r'^page6auto/$', 'auto.page6.Page6', name='Page6'),
    url(r'^page7auto/$', 'auto.page7.Page7', name='Page7'),
    url(r'^page7auto2/$', 'auto.page7.Page72', name='Page72'),
    url(r'^page7auto3/$', 'auto.page7.Page73', name='Page73'),
    url(r'^page8auto/$', 'auto.page8.Page8', name='Page8'),
    url(r'^page9auto/$', 'auto.page9.Page9', name='Page9'),
    url(r'^page9autoadd/$', 'auto.page9.Add', name='Add'),
    url(r'^page9autoedit/$', 'auto.page9.Edit', name='Edit'),
    url(r'^page10auto/$', 'auto.page10.List', name='List'),
    url(r'^page10autoadd/$', 'auto.page10.Add', name='Add'),
    url(r'^autoprinttask/$', 'auto.printform.TaskPrint', name='TaskPrint'),



    url(r'^ithelpdesk/$', 'ithelpdesk.views.ItHelpDesk', name='ItHelpDesk'),
    url(r'^ittask/$', 'ithelpdesk.task.ItTask', name='ItTask'),
    url(r'^ittasknew/$', 'ithelpdesk.task.ItTaskNew', name='ItTaskNew'),
    url(r'^ittaskclone/$', 'ithelpdesk.task.ItTaskClone', name='ItTaskClone'),
    url(r'^ittaskedit/$', 'ithelpdesk.task.ItTaskEdit', name='ItTaskEdit'),
    url(r'^itemail/$', 'ithelpdesk.task.ItTaskEmail', name='ItTaskEmail'),
    url(r'^itstatus/$', 'ithelpdesk.task.ItStatus', name='ItStatus'),
    url(r'^itmesuser/$', 'ithelpdesk.task.ItMesUser', name='ItMesUser'),
    url(r'^itreport/$', 'ithelpdesk.report.ItReport', name='ItReport'),
    url(r'^itopt/$', 'ithelpdesk.opt.ItOpt', name='ItOpt'),
    url(r'^itoptemail/$', 'ithelpdesk.opt.ItOptEmail', name='ItOptEmail'),

    url(r'^itmy/$', 'ithelpdesk.my.ItMy', name='ItMy'),
    url(r'^ittaskuser/$', 'ithelpdesk.my.ItTaskUser', name='ItTaskUser'),
    url(r'^itmessuser/$', 'ithelpdesk.my.ItMessUser', name='ItMessUser'),
    url(r'^itnewmess/$', 'ithelpdesk.my.ItNewMess', name='ItNewMess'),
    url(r'^itnewtaskuser/$', 'ithelpdesk.my.ItNewTaskUser', name='ItNewTaskUser'),



    url(r'^store/$', 'store.views.List', name='List'),
    url(r'^storelist/$', 'store.storelist.StoreList', name='StoreList'),
    url(r'^storelistnew/$', 'store.storelist.StoreNew', name='StoreNew'),
    url(r'^storelistedit/$', 'store.storelist.StoreEdit', name='StoreEdit'),
    url(r'^storeperson/$', 'store.storeperson.StorePersonList', name='StorePersonList'),
    url(r'^storepersonnew/$', 'store.storeperson.StorePersonNew', name='StorePersonNew'),
    url(r'^storeone/$', 'store.one.One', name='One'),
    url(r'^storerest/$', 'store.one.OneRest', name='OneRest'),
    url(r'^storeonein/$', 'store.onein.OneIn', name='OneIn'),
    url(r'^storeprocess/$', 'store.one.OneProcess', name='OneProcess'),
    url(r'^storeoneininfo/$', 'store.ajaxservice.StoreOneInInfo', name='StoreOneInInfo'),
    url(r'^storetmc/$', 'store.storetmc.StoreTmc', name='StoreTmc'),
    url(r'^storereports/$', 'store.storereport.StoreReport', name='StoreReport'),
    url(r'^storetmcchoice/$', 'store.storetmc.StoreTmcChoice', name='StoreTmcChoice'),
    url(r'^storereserve/$', 'store.one.OneReserve', name='OneReserve'),
    url(r'^storeoneout/$', 'store.one.OneOut', name='OneOut'),
    url(r'^storeoneoutnew/$', 'store.oneout.OneOutNew', name='OneOutNew'),
    url(r'^storeoneoutinfo/$', 'store.ajaxservice.StoreOneOutInfo', name='StoreOneOutInfo'),


    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    url(r'css/(?P<path>.*)$','django.views.static.serve',{'document_root':'/home/task/kis/kis/static/css/',}),
    url(r'js/(?P<path>.*)$','django.views.static.serve',{'document_root':'/home/task/kis/kis/static/js/',}),
    url(r'fonts/(?P<path>.*)$','django.views.static.serve',{'document_root':'/home/task/kis/kis/static/fonts/',}),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
