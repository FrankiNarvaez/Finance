class Category < ApplicationRecord
  belongs_to :account
  has_many :transactions

  validates :name, presence: true
end
