class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.string :name, null: false
      t.integer :type, null: false
      t.integer :amount, null: false
      t.text :description
      t.date :date, null: false
      t.references :account, null: false, foreign_key: true
      t.references :bank, null: false, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
