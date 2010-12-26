require 'hpricot'
require 'rest-open-uri'

class HottrendsController < ApplicationController
  
  # GET api/hottrends/2009-8-16 (:date)
  # GET api/hottrends/2009-8-16.xml (:date)
  def api_day
    date = params[:date].to_date
    create_hot_trends_if_not_in_db(date)
    
    @hottrends = Hottrend.where(:date => date).order(:num)
    
    respond_to do |format|
      format.html # api_day.html.erb
      format.xml  { render :xml => @hottrends }
      format.json  { render :json => @hottrends }
    end
  end

  # GET api/hottrends/2009-8-16/2009-8-24 (:start_date/:end_date)
  # GET api/hottrends/2009-8-16/2009-8-24.xml (:start_date/:end_date)
  def api_period
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date
    create_hot_trends_if_not_in_db_by_period(@start_date, @end_date)

    @hottrends = Hottrend.where("date IN (?)", (@start_date)..(@end_date)).order(:date).order(:num)
    
    respond_to do |format|
      format.html # api_period.html.erb
      format.xml  { render :xml => @hottrends }
      format.json  { render :json => @hottrends }
    end
  end

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

  def create_hot_trends_if_not_in_db_by_period(start_date, end_date)
    while start_date <= end_date
      create_hot_trends_if_not_in_db(start_date)
      start_date = start_date.+(1)
    end
  end
  
  def create_hot_trends_if_not_in_db(date)
    if Hottrend.where(:date => date).empty?
      create_hot_trends_in_db(date)
    elsif (date.day == Time.now.day and date.month == Time.now.month and date.year == Time.now.year)
      destroy_hot_trends_in_db(date)
      create_hot_trends_in_db(date)
    end
  end

  def destroy_hot_trends_in_db(date)
    date = date.to_s
    hts = Hottrend.where(:date => date.to_date)
    hts.each do |ht|
      ht.destroy
    end
  end

  def create_hot_trends_in_db(date)
    date = date.to_s
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    my_html = ""
    url = "http://www.google.com/trends/hottrends?date="+date
    page = open(url, hdrs).each {|s| my_html << s}
    @web_doc =  Hpricot(my_html)

    @i = 0
    (@web_doc/"td.hotColumn").search("a").each do |e|
      Hottrend.create(:date => date.to_date, :text => e.inner_html, :num => @i, :culture => "en_US")
      @i += 1
    end
  end

end
