require_relative 'environment'
require_relative 'YelpBiz'



def make_bizs(dev = false)
  # if dev #load results from file
  #   #all_bizs = YAML.load(File.read('./all_bizs.yml'))
  #   all_bizs.each {|biz| biz.recheck_open}
  #   YelpBiz.all= (all_bizs)
  
  # else
    #set variables need for yelp gem
    params = {term: 'food',limit: 20, sort: 1}
    locale = {lang: 'eng'}
    yelp_api_results = Yelp::Client.new(YelpBiz.get_api_key)

    #  yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses.each_with_index do |value, index|
    #   name = value.name
    #   address = value.location.address.shift
    #   image = value.image_url 
    #   url = value.url
    #   categories= value.categories[0]
    #   rating = value.rating
    #   hours = YelpBiz.get_hours(url,index)
    #   distance= (value.distance*0.00062137).round(2)
    #   YelpBiz.new(name,address,image,url,categories,rating,hours,distance)
    # end
    # puts "make biz done"
    # all_bizs = YelpBiz.all
# end

    search1 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[0..1].each_with_index do |value, index|
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
    }

    search2 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[2..3].each_with_index do |value, index|
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
    }

    search3 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[4..5].each_with_index do |value, index|
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
    }



     search4 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[6..7].each_with_index do |value, index|
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
    }

    search5 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[8..9].each_with_index do |value, index|
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
    }

    search6 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[10..11].each_with_index do |value, index|
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
    }

     search7 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[12..13].each_with_index do |value, index|
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
    }
     search8 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[14..15].each_with_index do |value, index|
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
    }
     search9 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[16..17].each_with_index do |value, index|
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
    }
     search10 = Thread.new {
      yelp_api_results.search_by_coordinates(YelpBiz.loc,params,locale).businesses[18..19].each_with_index do |value, index|
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
    }
    
  

    search1.join
    search2.join
    search3.join
    search4.join
    search5.join
    search6.join
    search7.join
    search8.join
    search9.join
    search10.join


    all_bizs = YelpBiz.all 
   
    
end

