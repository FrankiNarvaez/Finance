class User < ApplicationRecord
  after_save :create_account
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :account, dependent: :destroy

  def create_account
    Account.create(user_id: id)
  end
end
