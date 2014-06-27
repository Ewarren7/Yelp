require_relative 'environment'

class YelpBiz
  attr_reader :name :address :image :url :categories :hours  
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
      puts "Got"
      print i 
      parse = Nokogiri::HTML(open("#{url}",HEADERS_HASH))
      parse.search("span.hour-range").collect {|name| name.text}
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
    @@all << self
  end


end#class