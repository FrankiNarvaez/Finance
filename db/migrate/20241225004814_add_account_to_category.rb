class AddAccountToCategory < ActiveRecord::Migration[8.0]
  def change
    add_reference :categories, :account, null: false, foreign_key: true
  end
end
