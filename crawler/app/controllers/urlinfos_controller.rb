class UrlinfosController < ApplicationController
  # GET /urlinfos
  # GET /urlinfos.xml
  def index
    @urlinfos = Urlinfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @urlinfos }
    end
  end

  # GET /urlinfos/1
  # GET /urlinfos/1.xml
  def show
    @urlinfo = Urlinfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @urlinfo }
    end
  end

  # GET /urlinfos/new
  # GET /urlinfos/new.xml
  def new
    @urlinfo = Urlinfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @urlinfo }
    end
  end

  # GET /urlinfos/1/edit
  def edit
    @urlinfo = Urlinfo.find(params[:id])
  end

  # POST /urlinfos
  # POST /urlinfos.xml
  def create
    @urlinfo = Urlinfo.new(params[:urlinfo])

    respond_to do |format|
      if @urlinfo.save
        flash[:notice] = 'Urlinfo was successfully created.'
        format.html { redirect_to(@urlinfo) }
        format.xml  { render :xml => @urlinfo, :status => :created, :location => @urlinfo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @urlinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /urlinfos/1
  # PUT /urlinfos/1.xml
  def update
    @urlinfo = Urlinfo.find(params[:id])

    respond_to do |format|
      if @urlinfo.update_attributes(params[:urlinfo])
        flash[:notice] = 'Urlinfo was successfully updated.'
        format.html { redirect_to(@urlinfo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @urlinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /urlinfos/1
  # DELETE /urlinfos/1.xml
  def destroy
    @urlinfo = Urlinfo.find(params[:id])
    @urlinfo.destroy

    respond_to do |format|
      format.html { redirect_to(urlinfos_url) }
      format.xml  { head :ok }
    end
  end
end
