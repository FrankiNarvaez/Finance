class AddParentConection < ActiveRecord::Migration[8.0]
  def change
    add_reference :accounts, :parent, foreign_key: { to_table: :users }, index: true, null: true
  end
end
