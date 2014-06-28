require_relative 'environment'

class YelpBiz
  attr_reader :name, :address, :image, :url, :categories, :hours, :yelp_biz_hours  
  HEADERS_HASH = {"User-Agent" => "Ruby/#{RUBY_VERSION}"}
  @@all = []
  
  ####Class Var Readers#######
  def self.params
    @@params
  end

  def self.locale
    @@locale
  end
    def self.all
    @@all
  end

  def self.client
    @@client
  end

  ######Calss Methods########
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

  def self.get_all_nearby
    @@params = {term: 'food',limit: 20, sort: 1}
    @@locale = {lang: 'eng'}
    @@client = Yelp::Client.new(self.get_api_key)
  end

  def self.loc
    page = "http://freegeoip.net/json/"
    doc = Nokogiri::HTML(open(page, 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.153 Safari/537.36'))
    loc = /(latitude)(\":)(\d+.\d+)(,\"longitude\":)(-\d+.\d+)/.match(doc.text)
    return {latitude: loc[3], longitude: loc[5]}
  end

  
  def self.get_all_biz_urls
    @@client.search_by_coordinates(self.loc,@@params,@@locale).businesses.collect {|x| x.url }
  end

  def self.get_all_closing_hours
    puts "Scraping for biz hours"
    urls = get_all_biz_urls
    i=0
    hours = urls.collect do |url| 
      puts "Got #{i}"
      i+=1 
      parse = Nokogiri::HTML(open("#{url}",HEADERS_HASH))
      parse.search("span.hour-range").collect {|name| name.text}
    end
  end

  def self.conv_biz_hrs(time)
    time<<"0:00 pm - 00:00 pm" if time.length == 0 #account for ones without times listed
    times = time.first.to_s.split(" - ")
    
    o_times= /(\d+)(:)(\d+)( )([a-z]+)/.match(times[0])
    c_times= /(\d+)(:)(\d+)( )([a-z]+)/.match(times[1])
    o_hour= o_times[1].to_i
    o_min= o_times[3].to_i
    o_am = o_times[5] == "am"
    c_hour= c_times[1].to_i
    c_min= c_times[3].to_i
    c_am = c_times[5] == "am"
    if c_am #account for ones that close early morning next day
      c_hour+=24
    end
    
    yelp_biz_hours = {o_hour: o_hour, o_min: o_min, o_am: o_am, c_hour: c_hour, c_min: c_min, c_am: c_am}
    "#{c_hour}#{c_min}".to_i

   end

  def self.is_open?(hours1)
    
    now_hour= Time.new.hour
    Time.new.min < 10 ? now_min = "0#{Time.new.min}" : Time.new.min
    binding.pry
    "#{now_hour}#{now_min}".to_i < self.conv_biz_hrs(hours1)
  end

  ########Instance Methods############
  def initialize (name,address,image,url,categories,rating, hours)
    
    @name = name
    @address = address
    @image= image
    @url= url
    @categories= categories
    @hours = hours
    @open_now = self.class.is_open?(@hours)

    @@all << self
  end




end#class