# frozen_string_literal: true
class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams, force: true do |t|
      t.integer :platform, null: false, default: 0
      t.string :team_id, null: false
      t.string :name, null: false
      t.string :bot_user_id
      t.string :bot_token, null: false
      t.string :user_id
      t.string :user_token
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :teams, %i[platform team_id], unique: true
    add_index :teams, %i[platform bot_user_id], unique: true
    add_index :teams, %i[platform bot_token], unique: true
    add_index :teams, %i[platform user_id], unique: true
    add_index :teams, %i[platform user_token], unique: true
    add_index :teams, :name
  end
end
