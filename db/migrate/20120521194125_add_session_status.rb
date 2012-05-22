class AddSessionStatus < ActiveRecord::Migration
  def up
    add_column :sessions, :status, :string, :default => 'new'
  end

  def down
    remove_column :sessions, :status
  end
end
