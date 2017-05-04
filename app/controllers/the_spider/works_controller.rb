require_dependency 'the_spider/application_controller'
module TheSpider
  class WorksController < ApplicationController
    before_action :set_work, only: [:show, :edit, :update, :destroy]

    def index
      @works = Work.all
    end

    def show
    end

    def new
      @work = Work.new
    end

    def edit
    end

    def create
      @work = Work.new(work_params)

      if @work.save
        redirect_to @work, notice: 'Work was successfully created.'
      else
        render :new
      end
    end

    def update
      if @work.update(work_params)
        redirect_to @work, notice: 'Work was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @work.destroy
      redirect_to works_url, notice: 'Work was successfully destroyed.'
    end

    private
    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.fetch(:work, {})
    end
  end
end
