class Spider::Admin::SpiderResourcesController < Spider::Admin::BaseController
  before_action :set_spider_resource, only: [:show, :edit, :update, :destroy]

  def index
    @spider_resources = SpiderResource.page(params[:page])
  end

  def new
    @spider_resource = SpiderResource.new
  end

  def create
    @spider_resource = SpiderResource.new(spider_resource_params)

    if @spider_resource.save
      redirect_to admin_spider_resources_url, notice: 'Spider resource was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @spider_resource.update(spider_resource_params)
      redirect_to admin_spider_resources_url, notice: 'Spider resource was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @spider_resource.destroy
    redirect_to admin_spider_resources_url, notice: 'Spider resource was successfully destroyed.'
  end

  private
  def set_spider_resource
    @spider_resource = SpiderResource.find(params[:id])
  end

  def spider_resource_params
    params.fetch(:spider_resource, {}).permit(
      :code,
      :xpath,
      :css,
      :squish
    )
  end

end
