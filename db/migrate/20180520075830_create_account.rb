# frozen_string_literal: true

class CreateAccount < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.decimal :balance, null: false

      t.timestamps
    end
  end
end
