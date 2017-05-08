module TheSpider
  class Work < ApplicationRecord

    def resource
      @resource ||= Resource.new(host: host, list_path: list_path, item_path: item_path, page_params: page_params)
    end

    def run
      @resource.run
    end

  end
end
