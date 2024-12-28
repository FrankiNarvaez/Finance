class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :account, ->(id) { where(account_id: id) }
end
