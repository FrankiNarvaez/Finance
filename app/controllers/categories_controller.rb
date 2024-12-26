class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]

  def index
    @categories = Category.account(current_user.account)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    @category.account_id = current_user.account.id

    if @category.save
      redirect_to root_path, notice: t(".created", name: @category.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to root_path, notice: t(".updated", name: @category.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to root_path, status: :see_other, notice: t(".deleted")
  end

  private

  def category_params
    params.require(:category).permit(:name, :icon)
  end

  def set_category
    @category ||= Category.find(params[:id])
  end
end
