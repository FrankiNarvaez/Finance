class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :bank
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :date, presence: true

  scope :account, ->(id) { where(account_id: id) }
end
