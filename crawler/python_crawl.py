#!/usr/bin/python
import os
import sys
import re
import urllib.request
import urllib.error
import urllib.parse
import mysql
from html.parser import HTMLParser

#try:

#    db=mysql.connect(host='localhost', user='root', passwd='', db='web_crawler')
#    cursor = db.cursor()
#except mysql.Error:
#    print("DB Connection Problem")
#    exit(0)

global counter
counter = 0
print("Enter URL to crawl \n")
global url
#keep track of the crawled urls
traversed = []
#urls to be crawled
queue = []
url = sys.stdin.readline()
#cursor.executemany('INSERT INTO url (name) VALUES (%s) ON DUPLICATE KEY UPDATE id=id+1;',[url])
#make sure we don't visit a certain url more than once
def checkTraversed(list, list_id):
    for visited in list:

        visited = visited.replace("/", "")
        visited = visited.replace("http:", "")
        list_id = list_id.replace("/", "")
        list_id = list_id.replace("http:", "")
        visited.strip
        list_id.strip
        if(visited == list_id):
            return 1

    return 0
#checks whether a string is a substring of another string
def contains(string1, substr):
    return string1.find(substr)

#check for malformed html content
def validate(starturl):
        #handle exception for the http request
    try:
        starturl = starturl.strip()
        fstarturl = urllib.request.urlopen(starturl)
        result = fstarturl.read()
        #print(result)
        return result
        #print (result)
    #print (result)
    except:
        print("Unable to open", starturl)
        return "error"

#do a url validation
def urlTraverse(baseurl, counter):

    if (baseurl.startswith("www")):
        baseurl = "http://" + baseurl
    elif (not(baseurl.startswith("http://") and not (baseurl.startswith("www")))):
        baseurl = "http://" + baseurl
	
    if(validate(baseurl) != "error"):
        lst = str(validate(baseurl))
    elif(len(queue) > 0):
        skipUrl = queue.pop(0)
        traversed.append(skipUrl)
        urlTraverse(skipUrl, counter)
    else:
        print("Crawling Completed")
        sys.exit(0);

    href = re.compile("<a href=\"(.*?)\"")
    links = []
    links = href.findall(lst)
    title = []
    title_regex = re.compile("<title>(.*?)</title>")
    title = title_regex.findall(lst)
    if(len(title) > 0):
       for t in title:
           t = t.replace("\"", "")
           t = t.replace("\'", "")
           print("Title ", t)
    desc = []
    desc_regex = re.compile("<meta NAME|name=\"description\" content=(.*?)>")
    desc = desc_regex.findall(lst)
    if(len(desc) > 0):
        for d in desc:
            d = d.replace("\"", "")
            d = d.replace("\'", "")
            print("Description", d)
    
    for l in links:
        l = l.rstrip()
        l = l.lstrip()
        l = l.replace("./", "/")
        #l=l.replace("#","")
        baseurl = baseurl.rstrip()
        baseurl = baseurl.lstrip()
        checkUrl = url.replace("www.", "")
        checkUrl = checkUrl.replace("http://", "")
        checkUrl = checkUrl.rstrip()
        checkUurl = checkUrl.lstrip()

        if(not re.search("javascript", l) and not re.search(";", l)):

            if ((not(l.startswith("http://"))) and  (not(l.startswith("www"))) and (not(l.startswith("https://"))) and (not(l.startswith("/")))):
                l = baseurl + "/" + l
            if (l.startswith("/")):
                if(not baseurl.endswith("/")):
                    l = baseurl + l

            #check whether it's a local domain
            if (contains(l, checkUrl) > -1):

                queue.append(l)
    #print ("to be traversed ",len(queue)

    while(len(queue) > 0):
        next = queue.pop(0)
        if(checkTraversed(traversed, next) == 0):
            counter = counter + 1
            if(counter > 50):
                print("Maximum search depth reached.")
                #db.close()
                exit(0)
            print("Crawling ", next)
            traversed.append(next)
            urlTraverse(next, counter)


urlTraverse(url, counter)

