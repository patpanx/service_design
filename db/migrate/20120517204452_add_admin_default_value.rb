class AddAdminDefaultValue < ActiveRecord::Migration
  def up
    change_column :users, :admin, :boolean, :default => 0
  end

  def down
    change_column :users, :admin, :boolean, :default => 1
  end
end
