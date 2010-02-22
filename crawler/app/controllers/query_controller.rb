class QueryController < ApplicationController
	def index
		indexurl = params["u"]
		query = params["q"]
		if (indexurl != nil)
			indexurl = indexurl.strip
	
		result_query = ActiveRecord::Base.connection.select_all("SELECT * from url_searches where url_name=#{ ActiveRecord::Base.connection.quote(indexurl) }")
	    res = UrlSearch.all(:conditions =>"url_name LIKE '%#{indexurl}%' and (title LIKE '%#{query}%' or description LIKE '%#{query}%')")
		
		res.each { 
			|r|
			
			puts r.title,"\n"
			puts r.description,"\n"
		}
		
		@all_res = res
		@iurl = indexurl
		
	  end	
		
		
	end
end