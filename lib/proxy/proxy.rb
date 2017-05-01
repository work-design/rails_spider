require 'mechanize'

module EventSpider
	class Proxy
		#proxy list, http://proxy.com.ru/
		attr_accessor :proxy, :agent
		def initialize(proxys=nil)
      @proxy = proxys if proxys
      @agent = Mechanize.new
      @agent.open_timeout = 50
		end

    def self.proxy_list
      proxy_arr = []
      File.open(File.expand_path("../proxylists.txt", __FILE__), 'r').each_line do |line|
        ip, port = line.strip.split(':')
        proxy_arr << {ip: ip.strip, port: port.to_i}
      end
      proxy_arr.uniq
    end

    def validate_proxy(proxy_array, host='http://www.douban.com')
      proxys_arr = []
      proxy_array.each do |proxy_hash|
        #break if proxys.size >= 400
        page = get_page_from(host, proxy_hash, nil,1)
        if page
          puts "validate #{proxy_hash}"
          proxys_arr << proxy_hash
        else
          puts "#{proxy_hash} not validated"
        end
      end
      proxys_arr
    end

    def write_proxy_to_file(proxys)
      file_name = 'proxylists.txt'
      file_path = File.expand_path('../', __FILE__)
      file = "#{file_path}/#{file_name}"
      unless proxys.blank?
        s = ''
        proxys.uniq.each{|proxy| s += "#{proxy[:ip]}:#{proxy[:port]}\n"}
        rw_model = proxys.size >= 1000 ? 'w' : 'a+'
        File.open(file, rw_model) do |f|
          f.puts s
        end
      end
    end
    
    # http://www.xici.net.co/nn/
    def get_xici_proxy
      proxys = []
      url = 'http://www.xici.net.co/nn/'
      (0..10).each do |i|
        page_url = i >= 1 ? "#{url}#{i}" : url
        puts page_url
        page = get_page_from(page_url)
        next proxys if page.nil?
        trs = page.search('#ip_list tr')
        trs.shift
        trs.each do |tr|
          tds = tr.search('td')
          proxy_hash = {ip: tds[1].text.strip, port: tds[2].text.strip}
          puts proxy_hash
          proxys << proxy_hash
        end
      end
      proxys
    end

    # http://www.youdaili.cn/Daili/guonei/
    def get_youdaili_proxy
      proxys = []
      urls = ['http://www.youdaili.cn/Daili/http/',
            'http://www.youdaili.cn/Daili/guonei/',
            'http://www.youdaili.cn/Daili/guowai/']
      puts 'get youdaili page link'
      header = {
        'User-Agent'      => 'Mozilla/5.0 (Linux; U; Android 2.3.4; en-us; T-Mobile myTouch 3G Slide Build/GRI40) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1',
        'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language' => 'en-gb,en;q=0.5',
        'Accept-Encoding' => 'gzip,deflate',
        'Accept-Charset'  => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
        'Keep-Alive'      => '115', 
        'Connection'      => 'keep-alive',
        'Cache-Control'   => 'max-age=0',
        'Referer'         => 'http://www.baidu.com'
      }
      urls.each do |url|
        puts "from youdaili page #{url}"
        page = get_page_from(url, nil, header)
        next if page.nil?
        page.search('.newslist_line > li > a').each_with_index do |link, index|
          if index <= 2
            a_href = link.attr('href')
            puts "find proxy list page #{a_href}"
            proxy_page = get_page_from(a_href, nil, header)
            next if proxy_page.nil?
            proxys += youdaili_proxy(proxy_page)
            puts "find proxy #{proxys.count}"
          end
        end
      end
      proxys
    end

    def youdaili_proxy(page)
      proxys = youdaili_ip(page)
      puts "get proxy in current page #{proxys.count}"
      page_links = []
      # 获取分页并抓取其中的IP
      pagelist = page.search('.pagelist li a')
      pagelist.shift
      pagelist.each do |lia|
        if lia.attributes['href'].value =~ /\d+\_\d\.html/
          page_links << lia.attributes['href'].value
        end
      end
      pagelist_uri = page.uri.to_s.gsub(/\d+\.html/, '')
      page_links.uniq.each do |link|
        pagelist_url = "#{pagelist_uri}#{link}"
        puts "paginate page #{pagelist_url}"
        page = get_page_from(pagelist_url)
        next if page.nil?
        proxys += youdaili_ip(page)
        puts "proxy size #{proxys.count}"
      end
      proxys
    end

    def youdaili_ip(page)
      proxys = []
      page.search('.cont_font p').first.children.text.strip.split("\r\n").each do |iptext|
        ip, port = iptext.split('@HTTP#').first.split(':')
        proxys << {ip: ip, port: port.to_i}
      end
      proxys
    end
    
    # http://proxy.com.ru/list_1.html
    # http://www.free-proxy-list.net/
    def get_proxy_com
      proxys = []
      url = 'http://proxy.com.ru/list_1.html'
      page = get_page_from(url)
      page_indexs = []
      page.links.each do |link|
        if link.text =~ /\[\d+\]/
          index = link.text.strip.match(/\[(\d+)\]/)
          page_indexs << index[1] if index
        end
      end
      page_indexs.each do |i|
        page = agent.get("http://proxy.com.ru/list_#{i}.html")
        next if page.nil?
        page.search('td > font > table').first.children.search('tr').each_with_index do |tr, index|
          if index > 0
            proxys << {ip: tr.children[2].text, port: tr.children[3].text.to_i}
          end
        end
      end
      
      proxys
    end

    def self.get_allproxylists
      proxys = []
      File.open(File.expand_path("../allproxylists.txt", __FILE__), 'r').each_line do |line|
        ip, port = line.split('@HTTP#').first.split(':')
        proxys << {ip: ip, port: port.to_i}
      end
      proxys.uniq
    end

    def get_page_from(url, proxy_hash=nil, header=nil, repeat=5)
      if proxy_hash
        @agent.set_proxy proxy_hash[:ip], proxy_hash[:port] 
      elsif @proxy
        proxy_hash = @proxy[rand(@proxy.size)]
        @agent.set_proxy proxy_hash[:ip], proxy_hash[:port]
      end
      if header
        @agent.request_headers = header
      else
        @agent.request_headers = {
          "Accept"          => "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8", 
          "Accept-Encoding" => "gzip,deflate,sdch",
          "Accept-Language" => "en-US,en;q=0.8",
          "Cache-Control"   => "max-age=0",
          "Connection"      => "keep-alive",
          "User-Agent"      => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/33.0.1750.152 Safari/537.36"
        }
      end
      begin
        puts @agent.proxy_addr
        @agent.get(url)
      rescue => e
        i ||= 0
        if i < repeat
          i += 1
          puts "Retry #{i} by #{url}"
          if @proxy && proxy.nil?
            proxy_hash = @proxy[rand(@proxy.size)]
            @agent.set_proxy proxy_hash[:ip], proxy_hash[:port]
          end
          retry
        else
          puts 'can not get page'
          return
        end
      end
    end

	end
end
