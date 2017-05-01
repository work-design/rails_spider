module PriceHelper

  # example: 60 - 940元
  def deal_fee(str)
    fee = str.scan(/\d+/)

    if str.include?("免费")
      fee << "0"
    end
    if str.include?("FREE")
      fee << "0"
    end
    if str.include?("未知")
      fee << "未知"
    end
    fee = fee.uniq
    fee = fee.sort_by do |f|
      f.to_i
    end
    fee
  end

end
