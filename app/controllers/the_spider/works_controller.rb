require_dependency 'rails_spider/application_controller'
module RailsSpider
  class WorksController < ApplicationController
    before_action :set_work, only: [:show, :edit, :update, :run, :destroy]

    def index
      @works = Work.page(params[:page])
    end

    def show
    end

    def new
      @work = Work.new
    end

    def create
      @work = Work.new(work_params)

      if @work.save
        redirect_to @work, notice: 'Work was successfully created.'
      else
        render :new
      end
    end

    def edit
    end

    def update
      if @work.update(work_params)
        redirect_to @work, notice: 'Work was successfully updated.'
      else
        render :edit
      end
    end

    def run
      WorkJob.perform_later(@work.id)
    end

    def parser
      ParserJob.perform_later(@work.id)
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
      params.fetch(:work, {}).permit(:name, :parser_name, :host, :list_path, :item_path, :page_params)
    end
  end
end
