require 'kimurai'
class RailsSpider::Kimurai < Kimurai::Base
  @name = "simple_spider"
  @engine = :selenium_chrome
  @start_urls = ['https://one.work/']

  def parse(response, url:, data: {})
    binding.pry
  end


end
