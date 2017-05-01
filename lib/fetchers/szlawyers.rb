module Fetcher
  class Weibo < Base
    attr_accessor :links, :newlinks, :header, :keywords
    
    def initialize
      super
      config_json = {}
      File.open(File.expand_path('../weibo/config.json', __FILE__), 'r') do |f|
        config_json = JSON.parse f.read
      end
      @links = config_json['links']
      @newlinks = config_json['newlinks']
      @header = config_json['headers'].each{|hs| hs.merge!({"Cookie" => Cookie.last.value}) if Cookie.last}
      @mechanize.request_headers= @header[rand(@header.size)]
      @keywords = config_json['keywords']
    end

    def change_another_cookie
      @mechanize.request_headers= @header[rand(@header.size)]
    end

    def deal_kind(kind_text)
      case 
      when kind_text.include?("展览")
        "展览"
      else
        "其它"
      end
    end

    def deal_subkind(kind_text)
      case 
      when deal_kind(kind_text) == "展览"
        nil
      else
        nil
      end
    end

    def get_event_hash(event_page)
      logger.info "Start grab event_details"
      event_hash = {}
      event_hash[:face] = event_page.search(".glide_pic img").first.attr("src")
      if event_hash[:face] == "http://ww1.sinaimg.cn/thumb180/6f0b57d3jw1dhrosgfzi8g.gif"
        logger.info "#{event_hash[:face]} cann't be used"
        return
      end
      info = event_page.search(".ev_detail_cont")
      event_hash[:title] = info.search("h3").first.child.text.split.join(" ")
      #key_word = @keywords.detect{|k| event_hash[:title].include?(k)}
      #unless key_word.nil?
      #  logger.info "#{event_hash[:title]} contain #{key_word} cann't be used"
      #  return
      #end
      @keywords.each do |k|
        if event_hash[:title].include?(k)
          logger.info "#{event_hash[:title]} contain #{k} cann't be used"
          return
        end
      end
      keys, values = [],[]
      info_pair = info.search("p")
      info_pair.each do |ip|
        ip = ip.search("span")
        keys << ip.first.text
        values << ip.last.text
      end
      info_hash = {}
      keys.each_index do |i|
        info_hash[keys[i]] = values[i]
      end
      event_hash[:time] = "开始时间：" + info_hash["开始时间："] + "结束时间：" + info_hash["结束时间："]
      time_hash = time_parse(event_hash[:time])
      event_hash.merge!(time_hash)
      event_hash[:place] = info_hash["地　　点："]
      event_hash[:location] = transform(event_hash[:place])
      event_hash[:vendor] = info_hash["发 起 人："] || info_hash["组 织 者："]
      fee_text = info_hash["费　　用："]
      event_hash[:fee] = deal_fee(fee_text)
      
      /(\d+)/ =~ info_hash.keys.last
      event_hash[:joins_count] = $1.to_i
      event_hash[:interests_count] = 0
      
      kind_text = info.search("h3 .W_textb2").first.text
      event_hash[:kind] = deal_kind(kind_text)
      event_hash[:subkind] = deal_subkind(kind_text)
      logger.info "Weibo kind text #{kind_text} and kind:#{event_hash[:kind]} subkind:#{event_hash[:subkind]}"
      event_hash[:detail] = event_page.search(".event_page_main .ev_details").text.strip
      
      event_hash[:source] = "weibo"
      event_hash[:city] = @city
      event_id = 0
      if event_page.uri.to_s =~ /\/(\d+)$/
        event_hash[:event_id] = $1
      end
      event_hash[:url] = event_page.uri.to_s

      logger.info "End of grab event_details"
      event_hash
    end

    def update_event(url)
      log = "This url is grabbed and now update：#{url}"
      log(1, log)
      begin
        event_hash = get_event_hash(url)
      rescue => e
        change_another_cookie
        log = e.message
        log (3, log)
        log = e.backtrace
        log(3, log)
        i ||= 1; i += 1
        if i <= 5
          log = "get_event_hash: #{url}, 第#{i}次 retry ..."
          log(2, log)
          retry
        else
          #TODO
          log = "Fail to grab this url and record this url:#{url}"
          log(2, log)
          FailUrl.create(url: url, source: "weibo", flag: "spider")
          return
        end
      end
      begin
        event = Event.find_or_create_by(event_id: event_hash[:event_id])
        event.update_attributes(event_hash)
        log = "Updated a event with event_id: #{event_hash[:event_id]}"
        log(1, log)
        log = "Updated record of URL：#{event_hash[:url]}"
        log(1, log)
      end unless event_hash == "垃圾数据"
    end

    def grab_list_link(link)
      logger.info "Grab Link #{link}"
      page = page_by_url(link)
      return if page.nil?
      #event_links = page.search('.evlist_main.clearfix li .evlist_img > a').collect{|li| li.attributes['href'].value}
      event_links = get_event_links(page)
      pages_links = page.search('.W_pages.W_pages_comment a').select{|a| a.children.text =~ /\d+/}
      if pages_links.size >= 2
        pages_links.map!{|li| li.children.text.to_i}
        logger.info pages_links

        (2..pages_links.sort.last).each do |i|
          #http://event.weibo.com/eventlist?type=1&class=5&location=31
          #http://event.weibo.com/eventlist?type=1&class=5&location=31&order=time
          #http://event.weibo.com/eventlist?type=1&class=5&location=31&order=time&p=2
          event_list_url = "#{link}&p=#{i}"
          event_list_page = page_by_url(event_list_url)
          next if event_list_page.nil?
          #event_links += event_list_page.search('.evlist_main.clearfix li .evlist_img > a').collect{|li| li.attributes['href'].value}
          event_links += get_event_links(event_list_page)
        end
      end
      logger.info event_links.size
      event_links.each do |link|
        event_url = "http://event.weibo.com#{link}"
        event_page = page_by_url(event_url)
        return if event_page.nil?
        create_event(get_event_hash(event_page))
      end
    end

    def get_event_links(page)
      event_links = []
      page.search('.evlist_main.clearfix li').each  do |lia|
        if '[ 打折/促销 ]' != lia.search('.evlist_cont.intro .evlist_title .W_textb').first.text.strip
          event_links << lia.search('.evlist_img > a').first.attributes['href']
        end
      end
      event_links
    end
    
  end #class
end #EventSpider
