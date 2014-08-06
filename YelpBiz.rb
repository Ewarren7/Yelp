require_relative 'environment'

class YelpBiz
  attr_reader :name, :address, :image, :url, :categories, :yelp_biz_hours, :open_now, :lat, :lon, :rating,:categories,:distance
  attr_accessor :hours 
  HEADERS_HASH = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36"}
 
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

  ######Class Methods#############################
  def self.get_api_key
    path="./yelp_api_key.txt"
    api_keys = {
      :consumer_key => "rafKiIALsdfrzJApEFRKAQ",
      :consumer_secret => "KwwBZUvezUTV8az3j-6EYSW2YNg",
      :token => "JP3tJKYEbNeFNO_J7MlIRzIdWtlodlX-",
      :token_secret => "LlIJAA1JY1rHuYhfdPqq5xbz1FQ"}
    
    # File.open(path) do |fp|
    #   fp.each do |line|
    #     key, value = line.chomp.split(" ")
    #     api_keys[key.to_sym] = value
    #   end
    # end
     @@api_keys = api_keys
  end

  def self.set_location (lat,lon)
    sleep(1)
    if lat.nil?|| lon.nil? #if html5 location isnt passed, revert to this method
      page = "http://freegeoip.net/json/"
      doc = Nokogiri::HTML(open(page, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'))
      loc = /(latitude)(\":)(\d+.\d+)(,\"longitude\":)(-\d+.\d+)/.match(doc.text)
      @lat = loc[3]
      @lon = loc[5]
    else
      @lat = lat
      @lon = lon
    end

    
  end

  def self.loc
    #return hash in format used by Yelp API
    return {latitude: @lat, longitude: @lon}
  end


  def self.get_hours(url, index)
    #scrape for hours, return array with hours string
    # puts "Found #{index +1} fooderies, getting hours"
    puts url
    parse = Nokogiri::HTML(open("#{url}",HEADERS_HASH))
    puts "Got #{index}"
    parse.search("span.hour-range").collect {|name| name.text}
    
  end



  def self.conv_biz_hrs(time) # CONVERTS YELP TIME STRING INTO REGEX 
    
  
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
    return true if hours_from_yelp[0] == "Open 24 hours"

    return false if hours_from_yelp.length == 0 #account for ones without times listed
    
    yelp_biz_hours = conv_biz_hrs(hours_from_yelp)
    
    
    time_now = Time.new
    
    open_time = Time.new(time_now.year,time_now.month,time_now.day,yelp_biz_hours[:o_hour],yelp_biz_hours[:o_min])
    
    #account for biz closing next day early AM by adding 1 day to time object if close hour is AM
    if yelp_biz_hours[:c_am] && !yelp_biz_hours[:o_am]  #closes during AM and opened during pm
      close_time = Time.new(time_now.year,time_now.month,time_now.day + 1,yelp_biz_hours[:c_hour],yelp_biz_hours[:c_min])
    else !yelp_biz_hours[:c_am]
      close_time = Time.new(time_now.year,time_now.month,time_now.day,yelp_biz_hours[:c_hour],yelp_biz_hours[:c_min])      
    end
    
    return false if time_now < open_time #returns true or false that biz hasn't opened yet
    return time_now < close_time #returns true or false that current time is before biz closing time
  end

  def self.conv_to_mil_time (yhours)
    #if open during pm, add 12 hours to ohour, unless its noon
    if !yhours[:o_am] 
      yhours[:o_hour] = yhours[:o_hour] += 12 unless yhours[:o_hour] == 12 
    end
      
    #if close during pm, add 12 to chour (unless its 12 noon)
    yhours[:c_hour] = yhours[:c_hour] += 12 if !yhours[:c_am] unless yhours[:c_hour] == 12 
      
    #if closes at midnight, make chour 00
    yhours[:c_hour] = 00 if yhours[:c_am] && yhours[:c_hour] == 12 
      
    return yhours
  end
 
  def self.all_open  
    self.all.select {|place| place.open_now}
  end

  def self.random_open
    self.all_open.shuffle
  end

  def self.suffle_open

    @@random_open ||= YelpBiz.all_open.shuffle
    @@i + 1 == @@random_open.length ? @@i = 0 : @@i+=1
    @@random_open.each {|place| puts place.name}
    @@random_open[@@i]

  end

  #####debug class method
  def self.show_times #puts info to console to make sure time calcs working
   open= @@all.select { |biz| biz.open_now}
    open.each do |biz|
      puts biz.name
      puts biz.hours
      puts biz.get_biz_hours_array 
      puts ""
    end
  end

  ########Instance Methods############
  def initialize (name,address,image,url,categories,rating, hours, distance)
    @name = name
    @address = address
    @image= image
    @url= url
    @categories= categories
    @hours = hours
    @rating = rating
    @open_now = self.class.is_open?(@hours)
    @distance = distance
    @@all << self
  end
#### degubbing heper methods
  def recheck_open
    @open_now = self.class.is_open?(@hours)
  end

  def get_biz_hours_array
    self.class.conv_biz_hrs(@hours)
  end


end