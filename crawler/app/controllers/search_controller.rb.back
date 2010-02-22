require 'net/http'
require 'uri'

class SearchController < ApplicationController
  def index
  	url = params["q"]
	email = params["em"]

	#render :text => "Don't leave empty fields" 
		
	
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
	list = []
	html_cont.scan(/<a href=\"(.*?)\"/) {
	|href|
	#remove whitespaces
	href = href.to_s().strip
	if  !(href =~ /^https/) and !(href =~ /(javascript)/)
        	if !(href =~ /^http\:\/\//) and !(href =~ /^www/)

                	href = url+"/"+href
        	end
	        list.push(href)
	end
	}
	@all = list
	#render :text => list
  end

end
