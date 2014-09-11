class CreateNewCommentslist < ActiveRecord::Migration
  def change
    create_table :commentslists do |table|
      table.integer :user_id, null: false
      table.integer :meetup_id, null: false
      table.integer :comment_id, null: false

      table.timestamps
    end
  end
end
