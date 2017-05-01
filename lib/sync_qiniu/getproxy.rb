# encoding: utf-8
require 'rubygems'
require 'bundler'
Bundler.require

# Fetch proxy from: http://proxy.com.ru/
class ProxyList

  def initialize
    @proxylists = []
    @urls = []
    (1..2).each do |i|
      @urls << "http://proxy.com.ru/list_#{i}.html"
    end
  end

  def fetch_list
    @urls.each do |url|
		puts proxys_in_url(url).class
      @proxylists += proxys_in_url(url)
    end
    @proxylists.uniq!
    puts @proxylists
    puts "Fetched proxys #{@proxylists.size}"
  end

  alias :start :fetch_list

  def proxys_in_url(url)
    proxys = []
    agent = Mechanize.new
    page = agent.get(url)
  	list = page.search("body font table tr td:last font table tr")
  	list[1..-1].each do |tr|
  		ip = tr.search("td")[1].text
  		port = tr.search("td")[2].text
  		proxy = { ip: ip, port: port }
  		proxy = verify_proxy(proxy) # 比较费时间
  		proxys << proxy unless proxy == false
  		puts "add #{proxy} to proxys array..."
  	end 
  	return proxys
  end

  def get_urls
	  return @urls
  end
  
  def get_proxylists
	  return @proxylists
  end

  def save_proxylists
	pls = @proxylists.to_s
	puts pls
	if File.exist?("proxylists.txt")
	  File.rename("proxylists.txt","proxylists.txt.bak")
	end
	f = File.new("proxylists.txt","w+")
	f.write(pls)
	f.close
	puts "Save proxylists successfully."
  end

  def save_all_proxylists
	pls = @proxylists.to_s
	puts pls
	if File.exist?("allproxylists.txt")
	  File.rename("allproxylists.txt","allproxylists.txt.bak")
	end
	f = File.new("allproxylists.txt","w+")
	f.write(pls)
	f.close
	puts "Save all proxylists successfully."
  end

  def verify_proxy(proxy)
	ip, port = proxy[:ip], proxy[:port]
	testagent = Mechanize.new
	testagent.set_proxy ip, port
	testagent.read_timeout = 10
	begin
		page = testagent.get("http://www.baidu.com")	
		if page.title == "百度一下，你就知道"
		  return proxy
		puts 'That a good proxy'
		end
	rescue => e
		puts e.message
		puts 'That a bad proxy'
		proxy = nil
		return
	end
  end
end
