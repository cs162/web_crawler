class UrlSearchesController < ApplicationController
  # GET /url_searches
  # GET /url_searches.xml
  def index
    @url_searches = UrlSearch.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @url_searches }
    end
  end

  # GET /url_searches/1
  # GET /url_searches/1.xml
  def show
    @url_search = UrlSearch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @url_search }
    end
  end

  # GET /url_searches/new
  # GET /url_searches/new.xml
  def new
    @url_search = UrlSearch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @url_search }
    end
  end

  # GET /url_searches/1/edit
  def edit
    @url_search = UrlSearch.find(params[:id])
  end

  # POST /url_searches
  # POST /url_searches.xml
  def create
    @url_search = UrlSearch.new(params[:url_search])

    respond_to do |format|
      if @url_search.save
        flash[:notice] = 'UrlSearch was successfully created.'
        format.html { redirect_to(@url_search) }
        format.xml  { render :xml => @url_search, :status => :created, :location => @url_search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @url_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /url_searches/1
  # PUT /url_searches/1.xml
  def update
    @url_search = UrlSearch.find(params[:id])

    respond_to do |format|
      if @url_search.update_attributes(params[:url_search])
        flash[:notice] = 'UrlSearch was successfully updated.'
        format.html { redirect_to(@url_search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @url_search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /url_searches/1
  # DELETE /url_searches/1.xml
  def destroy
    @url_search = UrlSearch.find(params[:id])
    @url_search.destroy

    respond_to do |format|
      format.html { redirect_to(url_searches_url) }
      format.xml  { head :ok }
    end
  end
end
