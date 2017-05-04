require_dependency "the_spider/application_controller"

module TheSpider
  class WorksController < ApplicationController
    before_action :set_work, only: [:show, :edit, :update, :destroy]

    # GET /works
    def index
      @works = Work.all
    end

    # GET /works/1
    def show
    end

    # GET /works/new
    def new
      @work = Work.new
    end

    # GET /works/1/edit
    def edit
    end

    # POST /works
    def create
      @work = Work.new(work_params)

      if @work.save
        redirect_to @work, notice: 'Work was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /works/1
    def update
      if @work.update(work_params)
        redirect_to @work, notice: 'Work was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /works/1
    def destroy
      @work.destroy
      redirect_to works_url, notice: 'Work was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_work
        @work = Work.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def work_params
        params.fetch(:work, {})
      end
  end
end
