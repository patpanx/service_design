class Removinteger < ActiveRecord::Migration
  def up
    remove_column :positions, :timestamp
    add_column :positions, :timestamp, :timestamp
  end

  def down
    remove_column :positions, :timestamp
    add_column :positions, :timestamp, :integer
    
  end
end
