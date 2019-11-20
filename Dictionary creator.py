def create_syn_dict(word,num):
    
    counter=0.
    ed=(float(num)-1.0)*50.0
    
    from bs4 import BeautifulSoup
    import nltk
    from  urllib import request
    
    dict_syn={}

    url="https://www.powerthesaurus.org/"+str(word)+'/synonyms/'

    for  j in range(1,int(num)):
        url1=url+str(j)
        try:
            headers = { "User-Agent" :  "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)" }
            req = request.Request(url1, None, headers)
            resp = request.urlopen(req)
            contents = resp.read()
        except request.HTTPError as error:
            contents = error.read()


        
        ls=BeautifulSoup(contents,'html.parser').findAll('div',{"class":"pt-list-terms__item"})
        for i in range(len(ls)):
            try:
                counter+=1.0
                print('\r %.3f percent DONE' %round((counter)/ed*100.0-2.,3),end='')
                
                dict_syn[ls[i].findAll('a',{"class":"link link--primary link--term"})[0].text]=float(ls[i].findAll('div',{"class":"pt-list-rating__counter"})[0].text)
            except:
                pass
    return dict_syn
