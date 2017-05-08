module TheSpider
  class Fetcher

    def initialize
      @page = ''
    end

    def event_class
      @event_class = EventSpider.config.event_class.constantize
    end

    def page_by_url(url, proxy_hash=nil, header_hash=nil, repeat=5)
      logger.info "Grab the page #{url}"
      begin
        change_another_proxy(proxy_hash, header_hash)
        logger.info "Changed to a new proxy: #{@mechanize.proxy_addr}:#{@mechanize.proxy_port} for #{url}"
        page = @mechanize.get(url)
        logger.info "Has been get the page #{url}"
        page
      rescue => e
        logger.error e.message
        e.backtrace.each do |msg|
          error_log.error msg
        end
        error_log.error "\n"
        i ||= 0
        if i < repeat
          logger.info "Retry to get page for #{i} times"
          i += 1
          retry
        else
          if url.include?('douban')
            source = 'douban'
          elsif url.include?('weibo')
            source = 'weibo'
          elsif url.include?('rockbundartmuseum')
            source = 'waitan'
          elsif url.include?('citymoments')
            source = 'citymoment'
          else
            source = 'else'
          end
          FailUrl.create(url: url, source: source, flag: "spider")
          logger.warn "Cann't grab url #{url}"
          return
        end
      end
    end

    def save_page(page)
      begin
        page.save_as("html/#{Date.today.to_s}/#{page.uri.to_s.split('http://').last.chomp('/')}")
      rescue => e
        logger.error e.message
        logger.warn "cann't save page #{page.uri}"
      end
    end

    def change_another_proxy(proxy_hash=nil, header_hash=nil)
      if proxy_hash && proxy_hash[:ip] && proxy_hash[:port]
        ip = proxy_hash[:ip]
        port = proxy_hash[:port]
      else
        index = rand(@proxy.size)
        ip = @proxy[index][:ip]
        port = @proxy[index][:port]
      end
      @mechanize.set_proxy ip, port
      
      @mechanize.request_headers = header_hash unless header_hash.nil?
    end

    def is_grab?(url)
      event_class.where(url: url).exists? # 表示没有抓取
    end

    def run
      logger.info "Start #{self.class} Spider..."

      @links.each do |link|
        #@city = link.values.first
        grab_list_link(link.keys.first)
      end

      logger.info "End of #{self.class} Spider..."
    end

    def grab_update
      logger.info "Start #{self.class} Spider grab_update."

      @newlinks.each do |link|
        @city = link['city'] unless link['city'].blank?
        grab_list_link(link['url']) 
      end

      logger.info "End of #{self.class} Spider grab_update."
    end

    def create_event(event_hash)
      if event_hash.blank?
        logger.warn "Cann't create event by blank data"
        return
      end
      if is_existed?(event_hash)
        logger.warn "Paramter:#{event_hash} has been existed cann't to create"
        return
      end
      event = Event.new(event_hash)
      if event_hash[:place].blank?
        event.status = -1
      end
      event.kind_id = Kind.find_or_create_by(name: event_hash[:kind]).id unless event_hash[:kind].blank?
      event.subkind_id = set_subkind_id(event_hash[:subkind]) unless event_hash[:subkind].blank?
      if event_hash[:tags]
        event_hash[:tags].each do |t|
          EventTag.create(event_id: event.id, tag_id: Tag.find_or_create_by(name: t).id)
        end
      end
      event.int_id = Event.max(:int_id).blank? ? 1 : Event.max(:int_id) + 1
      event.save
      unless event.errors.blank?
        logger.info event.errors.full_messages.join(' / ')
      else
        logger.info 'Save event success'
      end
    end

    def is_existed?(event_hash)
      #if event_hash[:event_id] && event_class.where(event_id: event_hash[:event_id]).first
      #  return true
      #end
      # TODO title and city are the same
      #if event_hash[:title] && event_class.where(title: event_hash[:title]).first
      #  return true
      #end
      if event_hash[:url] && event = event_class.where(url: event_hash[:url]).first
        logger.warn "#{event_hash[:url]} has been exist in #{event.id}"
        return true
      end
      return false
    end

    def keep_on?; return true end # keep on grab?

  end
end
