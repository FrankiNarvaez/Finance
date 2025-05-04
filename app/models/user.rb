class User < ApplicationRecord
  after_save :create_account
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_one :account, dependent: :destroy
  has_many :child_accounts, class_name: "Account", foreign_key: :parent_id

  def create_account
    Account.create(user_id: id) unless Account.find_by(user_id: id)
  end
end
