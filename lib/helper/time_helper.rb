require 'time'

module TimeHelper
  def time_parse(str)
    date_hash = {}
    
    # 2014年1月11日 - 2014年4月20日
    # 2014年4月12日 星期六 15:00 - 18:00
    # 12月31日 ~ 2015年01月01日 每天20:00-22:00
    # 03月15日 ~ 06月07日 每周六、日 10:00-11:30
    # 04月01日 ~ 06月01日 每周二、三、五、日 08:00-20:30
    # 03月16日 ~ 06月08日 每周日 09:00-11:00
    # 07月26日 周六 19:30-22:30
    # 03月31日 ~ 06月17日 每周二至周日 14:00-16:30
    # 开始时间：1月9日 11:00(周四)结束时间：4月9日 00:00(周三)
    # 03月15日 ~ 06月01日 每天08:30-09:00
    # 03月19日 周三 19:30-21:00||||06月15日 周日 19:30-21:30 位置不要乱动||||
    #
    #     07月04日 周五 20:00-23:30
    #     07月05日 周六 20:00-23:30
    #     07月13日 周日 20:00-23:30
    #             
    # 7月08日 星期二 , 晚上 09:00 - 7月09日 星期三 , 凌晨 04:00 TODO

    date_hash.merge!(scan_time(str))
    date_hash.merge!(scan_week_day(str))
  end
  
  def scan_time str
    arr = str.scan(/(\d+:\d+)/).flatten
    if arr.size > 0
      time_begin = arr.first.to_time
      if arr.size > 1
        time_end = arr.last.to_time
      end 
      arr12 = str.scan(/晚上/)
      if arr12.size > 0
        if time_begin.hour <= 12
          time_begin += 12.hour
          time_end += 12.hour if str.scan(/凌晨/).blank? && time_end.hour <= 12
        end
      end
    end
    time_begin ||= '00:00'.to_time
    time_end ||= '00:00'.to_time
    { time_begin: time_begin.strftime("%H:%M"),
      time_end: time_end.strftime("%H:%M"),
      time_begin_seconds: time_begin.seconds_since_midnight,
      time_end_seconds: time_end.seconds_since_midnight}
  end

  def scan_week_day str
    week_day_hash = {
      "一" => 1,
      "二" => 2,
      "三" => 3,
      "四" => 4,
      "五" => 5,
      "六" => 6,
      "日" => 0,
    }
    # "03月15日 ~ 06月07日 每周六、日 10:00-11:30"
    # "04月01日 ~ 06月01日 每周二、三、五、日 08:00-20:30"
    arr = str.scan(/周(.)|、([一|二|三|四|五|六|日]){1,6}/)
    week_days = []
    if arr.size > 0
      week_days = arr.collect do |d|
        week_day_hash.values_at((d - [nil]).first).first
      end
    end
    # 03月31日 ~ 06月17日 每周二至周日 14:00-16:30
    arr = str.scan(/周(.)至周(.)/).flatten
    if arr.size > 0
      days = arr.map{|key| week_day_hash[key]}
      week_days = (days.first..(days-[0]).last).to_a
      week_days << 0 if days.include?(0)
      #if days.last == 0
      #  days[-1] = 6
      #  week_days = (days.first..days.last).to_a
      #  week_days << 0
      #else
      #  week_days = (days.first..days.last).to_a
      #end
    end 
    # 开始时间：1月9日 11:00(周四)结束时间：4月9日 00:00(周三)
    arr = str.scan(/\d+:\d+\(周[一|二|三|四|五|六|日]\)/)
    if arr.size == 2
      week_days = [1,2,3,4,5,6,0]
    end
    # 03月15日 ~ 06月01日 每天08:30-09:00
    arr = str.scan(/每天/)
    if arr.size > 0
      week_days = [1,2,3,4,5,6,0]
    end
    # 2014年4月12日 星期六 15:00 - 18:00
    arr = str.scan(/星期([一|二|三|四|五|六|日])/).flatten
    if arr.size > 0
      week_days = arr.map{|key| week_day_hash[key]}
    end
    
    date_hash = scan_date(str)
    days = get_days(date_hash[:date_begin], date_hash[:date_end], week_days)
    date_hash.merge({days: days, day_weekly: week_days})
  end

  def get_days(date_begin, date_end, week_days)
    if week_days.sort == [0,1,2,3,4,5,6]
      days = []
    elsif date_begin == date_end
      days = [date_begin.to_s]
    else
      days = (date_begin..date_end).select do |e|
        week_days.include?(e.wday)
      end
      days.collect{|d| d.to_s}
    end
  end

  def scan_date str
    arr = str.scan(/(\d+年)?(\d+)月(\d+)日/)
    arr.first[0] = arr.first[0].nil? ? Date.today.year.to_s : arr.first[0].chop
    date_begin = arr.first.join('-').to_date
    if arr.size > 1
      arr.last[0] = arr.last[0].nil? ? Date.today.year.to_s : arr.last[0].chop
      date_end = arr.last.join('-').to_date
    else
      date_end = date_begin
    end
    date_end = date_end.next_year if date_end < date_begin
    {date_begin: date_begin, date_end: date_end}
  end

  # "03月16日 ~ 06月08日 每周日 09:00-11:00"
  # "07月26日 周六 19:30-22:30"
  # arr = str.scan(/每周(.)/)
  # if arr.size > 0
  #   week_days = arr.first.map{|key| week_day_hash[key]}
  # end

end
