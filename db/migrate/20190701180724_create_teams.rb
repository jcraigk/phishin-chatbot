# frozen_string_literal: true
class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, force: true do |t|
      t.integer :platform, null: false, default: 0
      t.string :remote_id, null: false
      t.string :name, null: false
      t.string :bot_user_id
      t.string :token
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :teams, %i[remote_id platform], unique: true
    add_index :teams, %i[name platform], unique: true
  end
end
