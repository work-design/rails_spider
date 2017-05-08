module TheSpider
  class Work < ApplicationRecord

    def resource
      @resource ||= Resource.new(list, page_params, item)
    end

    def run
      @resource.run
    end

  end
end
