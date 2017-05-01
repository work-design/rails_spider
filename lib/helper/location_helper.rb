require 'net/http'

module LocationHelper

  def transform(str)
    url = URI.escape("http://api.map.baidu.com/geocoder/v2/?address=#{str}&output=json&ak=A38d59da730152d77b407446a3c0dd2b")
    # Geocoding API:  http://developer.baidu.com/map/webservice-geocoding.htm
    # http://api.map.baidu.com/geocoder/v2/?address=%E5%BE%90%E5%AE%B6%E6%B1%87&output=json&ak=A38d59da730152d77b407446a3c0dd2b&callback=showLocation
    begin
      response = Net::HTTP.get_response(URI(url))
      data = response.body  # response may be nil when net is bad
      # TODO
      result = JSON.parse(data)
      # status 说明文档:  http://developer.baidu.com/map/webservice-geocoding.htm#.E6.8E.A5.E5.8F.A3.E7.A4.BA.E4.BE.8A
      if result["status"] != 0
        location = [0.0, 0.0]
      else
        # {"status"=>0, "result"=>{"location"=>{"lng"=>121.48026424818, "lat"=>31.229092805768}, "precise"=>1, "confidence"=>80, "level"=>"道路"}}
        # puts result["result"]["location"]
        location = []
        location << result["result"]["location"]["lng"]
        location << result["result"]["location"]["lat"]
      end
      return location
    rescue SocketError
      i ||= 0
      if i <= 5
        i += 1
        retry
      else
        return [0.1, 0.1]
      end
    end
  end

  #def deal_location(location_text)
  #  if location_text.text != ""
  #    latitude = location_text.first.attr("content").to_f
  #    longitude = location_text.last.attr("content").to_f
  #    [longitude, latitude]
  #  else
  #    Location.transform(place)
  #  end
  #end

end
