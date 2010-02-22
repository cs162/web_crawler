require 'net/http'
require 'uri'
require 'thread'

class SearchController < ApplicationController
  
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
  

  def index
    queue = Queue.new
	traversed = [] 
  	visited = []
  	inputurl=params["q"]
	email = params["em"]
	counter1 = 0
	flag = "t"
	start = Time.now.to_f
  	crawl(inputurl,counter1,traversed,queue,flag,start,inputurl,email)
  end
  
  def crawl(baseurl,counter,traversed,queue,flag,start,origurl,email)
    
  if (flag == "t") 

    #render :text => "Don't leave empty fields" 
    
    baseurl = baseurl.strip
    if baseurl =~ /^www/
      baseurl = "http://"+baseurl
    elsif ( !(baseurl=~ /^http\:\/\//) && !(baseurl =~ /^www/) )
      baseurl = "http://"+baseurl
    end
    #handle exception
    begin
      html_cont = Net::HTTP.get URI.parse(baseurl)
    rescue
   	  flash[:notice] = "Unable to conntect to"+baseurl
	  print "Unable to conntect to "+baseurl
      return
    end
    #list = []
    html_cont.scan(/<a href=\"(.*?)\"/) {
      |href|
      #remove whitespaces
      href = href.to_s().strip
      if  !(href =~ /^https/) and !(href =~ /(javascript)/)
        if !(href =~ /^http\:\/\//) and !(href =~ /^www/)
          if(href =~ /^\//)
		    href = baseurl+href
		  else 
          	href = baseurl+"/"+href
		  end
        end
        #list.push(href)
        queue.push(href)
      end
    }
    
    title_result2=""
	html_cont.scan(/<title>(.*?)<\/title>/) {
      |title|
      title = title.to_s().strip
      title_result = title.gsub(/\'/, title)
      title_result2 = title.gsub(/\"/, title_result)
      print "Title "+title_result2+"\n"
      
    }
    
	desc_result2=""
    html_cont.scan(/<meta NAME|name=\"description\" content=(.*?)>/) {
      |desc|
      desc = desc.to_s().strip
      desc_result = desc.gsub(/\'/, desc)
      desc_result2 = desc.gsub(/\"/, desc_result)
      print "Description "+desc_result2+"\n"
      
    }
    
    
    endtime=0
    while(queue.length > 0)
      nexturl = queue.pop
      if(checkTraversed(traversed, nexturl) == 0)
        
        counter=counter+1
        if(counter > 50)

		  print("Maximum search depth reached.")
		  flag = "f"
		  queue.clear
		  endtime = Time.now.to_f
		  total = start - endtime 
    	  @all = "Crawling Successfully Completed & Total time =",total
		  send_email("crawl@Crawler.com","CR",email,"client","Crawling completed with total time #{total}","The url is http://localhost:3000/query?u=#{origurl}")
		  return
				  
        end
        entry = {}
        entry[:url_name] = nexturl
        entry[:title] = title_result2
        entry[:description] = desc_result2
        UrlSearch.create(entry)
        
		print nexturl + "\n"
        traversed.push(nexturl)
        crawl(nexturl,counter,traversed,queue,flag,start,origurl,email)
      end
    end

    #render :text => list
 end
 end


def send_email(from, from_alias, to, to_alias, subject, message)
	msg = "<<END
	From: #{from_alias} <#{from}>
	To: #{to_alias} <#{to}>
	Subject: #{subject}
	
	#{message}
	END"
	
	Net::SMTP.start('127.0.0.1') do |smtp|
		smtp.send_message msg, from, to
	end
end

end
