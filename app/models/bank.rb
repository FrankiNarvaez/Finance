class Bank < ApplicationRecord
  belongs_to :account
  has_many :transactions
  has_one_attached :picture
  has_one_attached :icon

  validates :name, presence: true
end
