class AddCommentIdToCommentslists < ActiveRecord::Migration
  def up
    add_column :commentslists, :comment_id, :integer, null: false
  end

  def down
  end
end
