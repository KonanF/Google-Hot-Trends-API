require 'hpricot'
require 'rest-open-uri'

class HottrendsController < ApplicationController
  
  # GET api/hottrends/2009-8-16/(5) (:date)(:limit)
  # GET api/hottrends/2009-8-16.xml (:date)
  # GET api/hottrends/2009-8-16/(5)/(asc|desc) (:date)(:limit)(:order)
  def api_day
    date = params[:date].to_date
    create_hot_trends_if_not_in_db_and_final_version(date)
    
    order = "num"
    if params[:order]
      order += " "+params[:order]
    end
    
    max_limit = 20
    offset = 0
    
    if params[:limit] && params[:order] && params[:order] == "desc"
      offset = 20 - params[:limit].to_i
    end
    
    @hottrends = Hottrend.where(:date => date).offset(offset).order(order).limit(params[:limit] ||= max_limit)
    
    respond_to do |format|
      format.html # api_day.html.erb
      format.xml  { render :xml => @hottrends  }
      format.json  { render :json => @hottrends }
      format.text { render :text => render_txt(@hottrends, date) }
    end
  end
  
  # GET api/hottrends/2009-8-16/2009-8-24/(5) (:start_date/:end_date)(:limit)
  # GET api/hottrends/2009-8-16/2009-8-24.xml (:start_date/:end_date)
  # GET api/hottrends/2009-8-16/2009-8-24.xml/(5)/(asc|desc) (:start_date/:end_date)(:limit)(:order)
  def api_period
    @start_date = params[:start_date].to_date
    @end_date = params[:end_date].to_date

    create_hot_trends_if_not_in_db_and_final_version_by_period(@start_date, @end_date)
    
    @hottrends = []
    date = @start_date
    while date <= @end_date
      @hottrends += Hottrend.where(:date => date).order(:num).limit(params[:limit] ||= "20")
      date = date.+(1)
    end
    
    respond_to do |format|
      format.html # api_period.html.erb
      format.xml  { render :xml => @hottrends }
      format.json  { render :json => @hottrends }
      format.text { render :text => render_txt(@hottrends, @start_date, @end_date ) }
    end
  end
  
  # GET api/hottrends/update/2009-8-16 (:date)
  def update_date
    date = params[:date].to_date   
    update date
    @hottrends = Hottrend.where(:date => date).order(:num).limit("20")
    
    respond_to do |format|
      format.html { render "hottrends/api_day" }
      format.xml  { render :xml => @hottrends  }
      format.json  { render :json => @hottrends }
      format.text { render :text => render_txt(@hottrends, date) }
    end
  end
  
  def create date
    date = date.to_s
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    my_html = ""
    url = "http://www.google.com/trends/hottrends?date="+date
    page = open(url, hdrs).each {|s| my_html << s}
    @web_doc =  Hpricot(my_html)
    
    @i = 0
    (@web_doc/"td.hotColumn").search("a").each do |e|
      @hottrend = Hottrend.new(:date => date.to_date, :text => e.inner_html, :num => @i, :culture => "en_US")
      @hottrend.save
      @i += 1
    end
  end
  
  def update date
    date = date.to_s
    hdrs = {"User-Agent"=>"Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.1.1) Gecko/20061204 Firefox/2.0.0.1", "Accept-Charset"=>"utf-8", "Accept"=>"text/html"}
    my_html = ""
    url = "http://www.google.com/trends/hottrends?date="+date
    page = open(url, hdrs).each {|s| my_html << s}
    @web_doc =  Hpricot(my_html)
    
    unless Hottrend.where(:date => date.to_date).first.nil?
      @i = 0
      (@web_doc/"td.hotColumn").search("a").each do |e|
        @hottrend = Hottrend.where(:date => date.to_date, :num => @i, :culture => "en_US").first
        @hottrend = @hottrend.update_attributes(:text => e.inner_html, :updated_at => Time.now)
        @i += 1
      end
    else
      create date
    end
  end
  
  # GET api/hottrends/destroy/2009-8-16 (:date)
  def destroy_date
    if params[:date].nil?
      @hottrend = Hottrend.find(params[:id])
      @hottrend.destroy
    else
      @hottrends = Hottrend.where(:date => params[:date].to_date)
      @hottrends.each do |h|
        h.destroy
      end
    end
    
    respond_to do |format|
      format.html { render :text => "ok" }
      format.xml  { head :ok }
    end
  end
  
  def create_hot_trends_if_not_in_db_and_final_version_by_period(start_date, end_date)
    while start_date <= end_date
      create_hot_trends_if_not_in_db_and_final_version(start_date)
      start_date = start_date.+(1)
    end
  end
  
  def create_hot_trends_if_not_in_db_and_final_version(date)
    hottrend = Hottrend.where(:date => date)
    if hottrend.empty?
      create date
    elsif (hottrend[0].updated_at <= hottrend[0].date)
      update date
    end
  end
  
  def render_txt hottrends, date, end_date = nil
    end_date ||= date
    text = ""
    
    while date <= end_date
      text += "#{date.strftime("%B %d, %Y")}\n" #October 31, 2010
      
      i = 1
      hottrends.each do |h|
        if h.date == date
          text += i.to_s+". "
          text += h.text+"\n"
          i+=1
        end
      end
      
      text += "\n"
      
      date = date.+(1)
    end

    return text
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

end
