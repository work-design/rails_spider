require_dependency "the_spider/application_controller"

module TheSpider
  class LocalsController < ApplicationController
    before_action :set_local, only: [:show, :edit, :update, :destroy]

    # GET /locals
    def index
      @locals = Local.page(params[:page])
    end

    # GET /locals/1
    def show
    end

    # GET /locals/new
    def new
      @local = Local.new
    end

    # GET /locals/1/edit
    def edit
    end

    # POST /locals
    def create
      @local = Local.new(local_params)

      if @local.save
        redirect_to @local, notice: 'Local was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /locals/1
    def update
      if @local.update(local_params)
        redirect_to @local, notice: 'Local was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /locals/1
    def destroy
      @local.destroy
      redirect_to locals_url, notice: 'Local was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_local
        @local = Local.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def local_params
        params.fetch(:local, {})
      end
  end
end
