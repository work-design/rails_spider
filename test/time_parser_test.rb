puts File.expand_path('../../models/time_parser.rb', __FILE__)
require File.expand_path('../../models/time_parser.rb', __FILE__)

require "minitest"
require "minitest/autorun"
require 'time'

class TestTimeParser < Minitest::Test
  def setup
    @parser = TimeParser
  end

  def test_one_day
    str = "07月12日 周六 20:30-22:00"
    result = @parser.parse(str) 
    assert_equal Date.parse("2014-07-12"), result[:start_date]
    assert_equal nil, result[:end_date]
    assert_equal Time.parse("20:30"), result[:start_time]
    assert_equal Time.parse("22:00"), result[:end_time]
  end

  def test_range_day_weibo
    str = "4月26日 周六 10:00 - 4月27日 周日 18:00"
    result = @parser.parse(str) 
    assert_equal Date.parse("2014-04-26"), result[:start_date]
    assert_equal Date.parse("2014-04-27"), result[:end_date]
    assert_equal Time.parse("10:00"), result[:start_time]
    assert_equal Time.parse("18:00"), result[:end_time]
  end

  def test_range_day
    str = "04月10日 ~ 04月26日 每天19:30-21:30"
    result = @parser.parse(str) 
    assert_equal Date.parse("2014-04-10"), result[:start_date]
    assert_equal Date.parse("2014-04-26"), result[:end_date]
    assert_equal Time.parse("19:30"), result[:start_time]
    assert_equal Time.parse("21:30"), result[:end_time]
  end 

  def test_range_week_day
    str = "05月21日 ~ 06月15日 每周三至周日 19:30-21:30"
    result = @parser.parse(str) 
    assert_equal Date.parse("2014-05-21"), result[:start_date]
    assert_equal Date.parse("2014-06-15"), result[:end_date]
    assert_equal Time.parse("19:30"), result[:start_time]
    assert_equal Time.parse("21:30"), result[:end_time]
    assert_equal [3, 4, 5, 6, 7], result[:week_days]
  end  
end