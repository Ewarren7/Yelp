require_relative 'environment'
require_relative 'YelpBiz'



def make_bizs(dev = false)
  if dev 
    all_bizs = YAML.load(File.read('./all_bizs.yml'))
    #all_bizs = all_bizsO.select {|biz| biz.name == "Gaia Italian Café"} #for testing biz with 2 closing times
    all_bizs.each {|biz| biz.recheck_open}
    
    YelpBiz.all= (all_bizs)
  
  else
    #set variables need for yelp gem
    params = {term: 'food',limit: 20, sort: 1}
    locale = {lang: 'eng'}
    yelp_api_results = Yelp::Client.new(YelpBiz.get_api_key)

    
    yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses.each_with_index do |value, index|
      name = value.name
      address = value.location.address.shift
      image = value.image_url 
      url = value.url
      categories= value.categories[0]
      rating = value.rating
      hours = YelpBiz.get_hours(url,index)
      distance= (value.distance*0.00062137).round(2)
      YelpBiz.new(name,address,image,url,categories,rating,hours,distance)
    end

    all_bizs = YelpBiz.all 
    File.open('./all_bizs.yml', 'w') {|f| f.write(YAML.dump(all_bizs)) } 
    
  end
end

