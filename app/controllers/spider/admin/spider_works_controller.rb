class Spider::Admin::SpiderWorksController < Spider::Admin::BaseController
  before_action :set_spider_work, only: [:show, :edit, :update, :destroy]

  def index
    @spider_works = SpiderWork.page(params[:page])
  end

  def new
    @spider_work = SpiderWork.new
    @spider_work.spider_resources.build
  end

  def create
    @spider_work = SpiderWork.new(spider_work_params)

    if @spider_work.save
      redirect_to admin_spider_works_url, notice: 'Spider work was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
    if @spider_work.spider_resources.count == 0
      @spider_work.spider_resources.build
    end
  end

  def update
    if @spider_work.update(spider_work_params)
      redirect_to admin_spider_works_url, notice: 'Spider work was successfully updated.'
    else
      render :edit
    end
  end

  def add_item
    @spider_work = SpiderWork.new
    @spider_work.spider_resources.build
  end

  def remove_item

  end

  def destroy
    @spider_work.destroy
    redirect_to admin_spider_works_url, notice: 'Spider work was successfully destroyed.'
  end

  private
  def set_spider_work
    @spider_work = SpiderWork.find(params[:id])
  end

  def spider_work_params
    params.fetch(:spider_work, {}).permit(
      :name,
      :host,
      :list_path,
      :item_path,
      :page_params,
      spider_resources_attributes: {}
    )
  end

end
