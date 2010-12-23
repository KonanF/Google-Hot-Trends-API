class HottrendsController < ApplicationController
  # GET /hottrends
  # GET /hottrends.xml
  def index
    @hottrends = Hottrend.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hottrends }
    end
  end
  
  # GET /hottrends/1
  # GET /hottrends/1.xml
  def show
    @hottrend = Hottrend.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hottrend }
    end
  end

  # GET /hottrends/new
  # GET /hottrends/new.xml
  def new
    @hottrend = Hottrend.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hottrend }
    end
  end

  # GET /hottrends/1/edit
  def edit
    @hottrend = Hottrend.find(params[:id])
  end

  # POST /hottrends
  # POST /hottrends.xml
  def create
    @hottrend = Hottrend.new(params[:hottrend])

    respond_to do |format|
      if @hottrend.save
        format.html { redirect_to(@hottrend, :notice => 'Hottrend was successfully created.') }
        format.xml  { render :xml => @hottrend, :status => :created, :location => @hottrend }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hottrend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hottrends/1
  # PUT /hottrends/1.xml
  def update
    @hottrend = Hottrend.find(params[:id])

    respond_to do |format|
      if @hottrend.update_attributes(params[:hottrend])
        format.html { redirect_to(@hottrend, :notice => 'Hottrend was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hottrend.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hottrends/1
  # DELETE /hottrends/1.xml
  def destroy
    @hottrend = Hottrend.find(params[:id])
    @hottrend.destroy

    respond_to do |format|
      format.html { redirect_to(hottrends_url) }
      format.xml  { head :ok }
    end
  end
end
