require_relative 'environment'
require_relative 'YelpBiz'
    
def init_bizs(dev = false)
  
  
  YelpBiz.get_all_nearby if !dev
  make_bizs(dev)
  
end

def make_bizs(dev = false)
  if dev 
    #raise '!!!!!!!dev mode active!!'
    all_bizs = YAML.load(File.read('./all_bizs.yml'))
    open_bizs = YAML.load(File.read('./open_bizs.yml'))
    YelpBiz.all= (all_bizs)
  
  else
    all_closing_hours = YelpBiz.get_all_closing_hours 
    
    YelpBiz.client.search_by_coordinates(YelpBiz.loc,YelpBiz.params,YelpBiz.locale).businesses.each_with_index do |value, index|
      name = value.name
      address = value.location.address.shift
      image = value.image_url
      url = value.url
      categories= value.categories[0]
      rating = value.rating
      hours = all_closing_hours[index]
      YelpBiz.new(name,address,image,url,categories,rating,hours)
    end

    all_bizs = YelpBiz.all 
    open_bizs= YelpBiz.all_open

   
    File.open('./all_bizs.yml', 'w') {|f| f.write(YAML.dump(all_bizs)) } 
    File.open('./open_bizs.yml', 'w') {|f| f.write(YAML.dump(open_bizs)) }
  end
end

