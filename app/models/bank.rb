class Bank < ApplicationRecord
  belongs_to :account
  has_many :transactions

  validates :name, presence: true

  scope :account, ->(id) { where(account_id: id) }
end
