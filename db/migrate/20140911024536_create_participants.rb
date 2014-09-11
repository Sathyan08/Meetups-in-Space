class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |table|
      table.integer   :user_id,   null: false
      table.integer   :meetup_id, null: false

      table.timestamps
    end
  end
end
