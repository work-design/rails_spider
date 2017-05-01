module TextHelper

  def deal_detail(detail_text)
    detail_text = detail_text.to_s.strip

    if detail_text.start_with?("活动详情")
      detail_text.sub!("活动详情", "")
      detail_text = detail_text.strip[1..-1] if detail_text.strip.start_with?(':')
    end
    if detail_text.index("查看全部")
      detail_text = detail_text[(detail_text.index("查看全部")+6)..-1]
      detail_text = detail_text.strip[1..-1] if detail_text.strip.start_with?('»')
    end
    if detail_text.end_with?("收起")
      detail_text.delete!("收起")
      detail_text = detail_text.strip.delete('«')
    end
    detail_text.strip
  end

  def set_subkind_id subkind
    case subkind
    when "现场", "音乐会", "演唱会", "音乐节", "小型现场"
      kind_id = Kind.find_or_create_by(name: "音乐").id
    when "话剧", "音乐剧", "舞剧", "歌剧", "戏曲"
      kind_id = Kind.find_or_create_by(name:"戏剧").id
    when "生活", "摄影", "外语", "桌游", "交友", "夜店", "集市"
      kind_id = Kind.find_or_create_by(name:"聚会").id
    when "景点"
      kind_id = Kind.find_or_create_by(name:"旅行").id
    when "主题放映", "影展", "影院活动"
      kind_id = Kind.find_or_create_by(name:"电影").id
    when "特别活动", "导览", "表演"
      kind_id = Kind.find_or_create_by(name:"其它").id
    else
      kind_id = Kind.find_or_create_by(name:"其它").id
    end
    Kind.find_or_create_by(name: subkind, kind_id: kind_id).id unless subkind.nil?
  end

end
