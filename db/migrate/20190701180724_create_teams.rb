# frozen_string_literal: true
class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams, force: true do |t|
      t.string :team_id
      t.string :name
      t.string :domain
      t.string :bot_user_id
      t.string :bot_token
      t.string :user_id
      t.string :user_token
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :teams, :team_id, unique: true
    add_index :teams, :name
  end
end
