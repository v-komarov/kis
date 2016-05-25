#coding:utf-8

from	django.db	import	connections, transaction




def	UserSave(user_kod,name1,name2,name3,email,phone):
    user_kod = user_kod.encode("utf-8")
    name1 = name1.encode("utf-8")
    name2 = name2.encode("utf-8")
    name3 = name3.encode("utf-8")
    email = email.encode("utf-8")
    phone = phone.encode("utf-8")
    cursor = connections['default'].cursor()
    cursor.execute("SELECT t_UserSave('%s','%s','%s','%s','%s','%s');" % (user_kod,name1,name2,name3,email,phone))
    transaction.commit_unless_managed()
    data = cursor.fetchone()
    return data[0]

