class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |table|
      table.string :subject, null: false
      table.text   :body,    null: false

      table.timestamps
    end
  end
end
