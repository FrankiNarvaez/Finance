class BanksController < ApplicationController
  before_action :set_bank, only: %i[ edit update destroy ]

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

  def bank_params
    params.require(:bank).permit(:name, :balance)
  end

  def set_bank
    @bank = Bank.find(params[:id])
  end
end
