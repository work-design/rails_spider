module TagHelper

  KINDS = /音乐|戏剧|讲座|聚会|电影|展览|运动|公益|旅行|派对/

  def deal_kind(str)
    kinds = str.scan(KINDS).first.to_s
    kinds = '其他' if kinds.blank?
    kinds
  end

  def deal_subkind(str)
    if str.include?("-")
      sub_kinds = str.slice((/-/ =~ str).to_i + 1,str.length)
    end
  end

end
