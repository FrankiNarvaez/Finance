class BanksController < ApplicationController
  before_action :set_bank, only: %i[ edit update destroy ]

  def index
    @banks = Bank.account(current_user.account.id)
  end

  def new
    @bank = Bank.new
  end

  def create
    @bank = Bank.new(bank_params)
    @bank.account_id = current_user.account.id

    if @bank.save
      redirect_to root_path, notice: t(".created", name: @bank.name)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @bank.update(bank_params)
      redirect_to root_path, notice: t(".updated", name: @bank.name)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bank.destroy
    redirect_to root_path, notice: t(".deleted"), status: :see_other
  end

  private

  def bank_params
    params.require(:bank).permit(:name, :balance)
  end

  def set_bank
    @bank ||= Bank.find(params[:id])
  end
end
