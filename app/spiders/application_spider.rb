require 'kimurai'
class ApplicationSpider < Kimurai::Base
  @name = "simple_spider"
  @engine = :selenium_chrome


  def parse
    parse_list
  end


  def parse_list

  end


end
