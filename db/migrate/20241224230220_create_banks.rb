class CreateBanks < ActiveRecord::Migration[8.0]
  def change
    create_table :banks do |t|
      t.string :name, null: false
      t.integer :balance, null: false, default: 0
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end
