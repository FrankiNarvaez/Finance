class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit udpate destroy ]

  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category ||= Category.find(params[:id])
  end
end
