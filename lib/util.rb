class Util 
  def self.batch_run(options = {}, &block)
    model = options[:model]
    raise "model must be provided" if model.blank?
    
    logger = options[:logger] || Logger.new(STDOUT)
    limit = options[:limit] || 400
    group_len = options[:group_len] || 100

    logger.info "#{model.name}.count #{model.count} at #{Time.now}"
    g_start_at = Time.now
    id = model.asc(:id).first.id 
    items = [""]
    while items.size > 0
      items = model.where(:id.gte => id).limit(limit).to_a
      threads = []
      items.each_slice(group_len).each do |_items|
        threads << Thread.new do
          _items.each do |item|
            begin
              yield item
            rescue => e
              logger.info "#{Time.now}\n#{e.message}\n#{e.backtrace.join("\n")}"
            end
          end # _items
        end # threads
      end # items
      threads.map(&:join)
      id = items.last.id
    end
    logger.info "Finish #{model.name}.count #{model.count} at #{Time.now} use #{Time.now - g_start_at}"
  end
end