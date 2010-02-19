#!/usr/bin/ruby
require 'net/http'
require 'uri'
require 'thread'


print "Enter url to crawl\n"
$baseurl = gets
counter = 0
$queue = Queue.new
$traversed = []

def checkTraversed(list,id)
  list.each {
    |visited|
    visited = visited.strip
    id = id.strip
    if(visited == id)
      return 1
    end
  }    
  return 0
  
end


def crawl(url,counter)
  url = url.strip
  if url =~ /^www/
    url = "http://"+url
  elsif ( !(url=~ /^http\:\/\//) && !(url =~ /^www/) )
    url = "http://"+url
  end
  #handle exception
  begin
    html_cont = Net::HTTP.get URI.parse(url)
  rescue
    
    print "Unable to conntect to "+url
    exit
  end
  #list = []
  html_cont.scan(/<a href=\"(.*?)\"/) {
    |href|
    #remove whitespaces
    href = href.to_s().strip
    if  !(href =~ /^https/) and !(href =~ /(javascript)/)
      if !(href =~ /^http\:\/\//) and !(href =~ /^www/)
        
        href = url+"/"+href
      end
      #list.push(href)
      $queue.push(href)
    end
  }
  
  html_cont.scan(/<title>(.*?)<\/title>/) {
    |title|
    title = title.to_s().strip
    title_result = title.gsub(/\'/, title)
    title_result2 = title.gsub(/\"/, title_result)
    print "Title "+title_result2+"\n"
    
  }
  
  html_cont.scan(/<meta NAME|name=\"description\" content=(.*?)>/) {
    |desc|
    desc = desc.to_s().strip
    desc_result = desc.gsub(/\'/, desc)
    desc_result2 = desc.gsub(/\"/, desc_result)
    print "Description "+desc_result2+"\n"
    
  }
  
  
  
  while($queue.length > 0)
    nexturl = $queue.pop
    if(checkTraversed($traversed, nexturl) == 0)
      
      counter=counter+1
      if(counter > 50)
        print("Maximum search depth reached.")
        exit(0)
      end
      
      print nexturl + "\n"
      $traversed.push(nexturl)
      crawl(nexturl,counter)
    end
  end   
end

crawl($baseurl,counter)