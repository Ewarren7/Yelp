require_relative 'environment'

class YelpBiz
  attr_reader :name, :address, :image, :url, :categories, :yelp_biz_hours, :open_now  
  attr_accessor :hours
  HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}"}
  @@all = []
  @@shuffled = []
  
  @@i = -1 #counter var for random restaurant method
 
  ####Class Var Readers & Writers#######
  
  def self.all
    @@all
  end


  def self.all= (all_yaml) #for loading from yaml
    @@all = all_yaml
  end

  ######Class Methods########
  def self.get_api_key
    path="../yelp_api_key.txt"
    api_keys = {}
    File.open(path) do |fp|
      fp.each do |line|
        key, value = line.chomp.split(" ")
        api_keys[key.to_sym] = value
      end
    end
     @@api_keys = api_keys
  end



  def self.loc
    page = "http://freegeoip.net/json/"
    doc = Nokogiri::HTML(open(page, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'))
    loc = /(latitude)(\":)(\d+.\d+)(,\"longitude\":)(-\d+.\d+)/.match(doc.text)
    return {latitude: loc[3], longitude: loc[5]}
  end


  def self.get_hours(url, index)
    puts "Found #{index +1} fooderies, getting hours"
    parse = Nokogiri::HTML(open("#{url}",HEADERS_HASH))
    parse.search("span.hour-range").collect {|name| name.text}
 
  end



  def self.conv_biz_hrs(time) # CONVERTS YELP TIME STRING INTO REGEX 
    return "no times" if time.length == 0 #account for ones without times listed
    times = time.first.to_s.split(" - ")
    
    o_times= /(\d+)(:)(\d+)( )([a-z]+)/.match(times[0])
    c_times= /(\d+)(:)(\d+)( )([a-z]+)/.match(times[1])
    o_hour= o_times[1].to_i
    o_min= o_times[3].to_i
    o_am = o_times[5] == "am"
    c_hour= c_times[1].to_i
    c_min= c_times[3].to_i
    c_am = c_times[5] == "am"
    
    yelp_biz_hours = {o_hour: o_hour, o_min: o_min, o_am: o_am, c_hour: c_hour, c_min: c_min, c_am: c_am}
    conv_to_mil_time (yelp_biz_hours) ##returns ohour and c hour in mil time. am and pm still included in hash
   end

  def self.is_open?(hours_from_yelp) #FINDS OUT IF A BUSINESS IS OPEN RETURNS BOOLEAN
    yelp_biz_hours = conv_biz_hrs(hours_from_yelp)
    return false if yelp_biz_hours == "no times"
    time_now = Time.new
    
    open_time = Time.new(time_now.year,time_now.month,time_now.day,yelp_biz_hours[:o_hour],yelp_biz_hours[:o_min])
    
    #account for biz closing next day early AM by adding 1 day to time object if close hour is AM
    if yelp_biz_hours[:c_am]
      close_time = Time.new(time_now.year,time_now.month,time_now.day + 1,yelp_biz_hours[:c_hour],yelp_biz_hours[:c_min])
    else !yelp_biz_hours[:c_am]
      close_time = Time.new(time_now.year,time_now.month,time_now.day,yelp_biz_hours[:c_hour],yelp_biz_hours[:c_min])      
    end
    
    return false if time_now < open_time #returns true or false that biz hasn't opened yet
    return time_now < close_time #returns true or false that current time is before biz closing time
  end

  def self.conv_to_mil_time (yhours)
    #if open during pm, add 12 hours to ohour
    if !yhours[:o_am] 
      yhours[:o_hour] = yhours[:o_hour] += 12 unless yhours[:o_hour] == 12 
    end
      
    #if close during pm, add 12 to chour
    yhours[:c_hour] = yhours[:c_hour] += 12 if !yhours[:c_am]
      
    #if closes at midnight hour, make chour 24
    yhours[:c_hour] = 24 if yhours[:c_am] && yhours[:c_hour] == 12
      
    return yhours
  end
 
  def self.all_open  
    self.all.select {|place| place.open_now}
  end

  def self.random_open
    self.all_open.shuffle
  end

  def self.suffle_open

    #binding.pry
    @@random_open ||= YelpBiz.all_open.shuffle
    @@i + 1 == @@random_open.length ? @@i = 0 : @@i+=1
    @@random_open.each {|place| puts place.name}
    @@random_open[@@i]

    #binding.pry
  end

  def self.show_times #puts info to console to make sure tiem calcs working
    @@all.each do |biz|
      puts biz.name
      puts biz.hours
      puts biz.get_biz_hours_array 
      puts ""
    end
  end

  ########Instance Methods############
  def initialize (name,address,image,url,categories,rating, hours)
    @name = name
    @address = address
    @image= image
    @url= url
    @categories= categories
    @hours = hours
    @rating = rating
    @open_now = self.class.is_open?(@hours)
    @@all << self
  end

  def recheck_open
    @open_now = self.class.is_open?(@hours)
  end

  def get_biz_hours_array
    self.class.conv_biz_hrs(@hours)
  end

  




end#class