module RailsSpider
  class WorkJob < ApplicationJob
    queue_as :default

    def perform(work_id)
      work = Work.find work_id
      work.resource.run
    end

  end
end
