class Category < ApplicationRecord
  belongs_to :account
  has_many :transactions
  has_one_attached :icon

  validates :name, presence: true

  scope :account, ->(id) { where(account_id: id) }
end
