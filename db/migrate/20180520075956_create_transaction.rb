# frozen_string_literal: true

class CreateTransaction < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :account, null: false
      t.decimal :amount, null: false
      t.date :date, null: false
      t.timestamps
    end
  end
end
