class BanksController < ApplicationController
  before_action :set_bank, only: %i[ edit update destroy ]

  def index
  end

  def new
    @bank = Bank.new
  end

  def create
    @bank = Bank.new(bank_params)
    @bank.account_id = current_user.account.id

    if @bank.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
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
