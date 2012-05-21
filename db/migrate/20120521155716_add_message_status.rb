class AddMessageStatus < ActiveRecord::Migration
  def up
    add_column :messages, :status, :string, :default => 'new'
  end

  def down
    remove_column :messages, :status
  end
end
