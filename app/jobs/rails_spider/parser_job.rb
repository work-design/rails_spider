module RailsSpider
  class ParserJob < ApplicationJob
    queue_as :default

    def perform(work_id)
      work = Work.find work_id
      work.parse
    end

  end
end
