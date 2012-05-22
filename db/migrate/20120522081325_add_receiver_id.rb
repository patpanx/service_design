class AddReceiverId < ActiveRecord::Migration
  def up
    add_column :sessions, :receiver_id, :integer
  end

  def down
    remove_column :sessions, :receiver_id
  end
end
