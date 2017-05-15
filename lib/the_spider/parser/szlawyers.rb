module TheSpider
  class Szlawyers < Parser

    def name
      doc.at_css('span#lawlist_LawerName').text
    end

    def sex
      doc.at_css('span#lawlist_LawerSex').text
    end

    def office
      doc.at_css('span#lawlist_Enterprise').text
    end

    # 资格证号
    def identify
      doc.at_css('span#lawlist_LawerqualNo').text
    end

    def time
      doc.at_css('span#lawlist_dtLawerqualNo').text
    end

  end
end
