class Transaction < ApplicationRecord
  include PgSearch::Model

  pg_search_scope :search_full_text, against: { name: "A", description: "B" }

  belongs_to :account
  belongs_to :bank
  belongs_to :category, optional: true

  validates :name, presence: true
  validates :amount, presence: true
  validates :transaction_type, presence: true
  validates :date, presence: true

  scope :account, ->(id) { where(account_id: id) }
end
