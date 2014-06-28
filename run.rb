require_relative 'environment'
require_relative 'YelpBiz'
    
def run
  
  
  YelpBiz.get_all_nearby
  make_bizs
  if YelpBiz.open_now == true 
  puts YelpBiz.name
  end
  binding.pry
end

def make_bizs
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

end

run