#!/usr/bin/python
#coding:utf-8

import pyrad.packet
from pyrad.client import Client
from pyrad.dictionary import Dictionary



def AuthUser(login,password,request):

    srv=Client(server="10.6.0.250", secret="secretttk",dict=Dictionary("kis/lib/dictionary", "kis/lib/dictionary.acc"))
      
    req=srv.CreateAuthPacket(code=pyrad.packet.AccessRequest,User_Name=login, NAS_Identifier="kis")
    req["User-Password"]=req.PwCrypt(password)
                    
    reply=srv.SendPacket(req)
    if reply.code==pyrad.packet.AccessAccept:
	request.session['key888'] = reply['Reply-Message']
	return "access accepted"
    else:
	return "access denied"
                            
    print "Attributes returned by server:"
    for i in reply.keys():
	print "%s: %s" % (i, reply[i])

