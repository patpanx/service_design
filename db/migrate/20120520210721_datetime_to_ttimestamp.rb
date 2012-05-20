class DatetimeToTtimestamp < ActiveRecord::Migration
  def up
    change_column :positions, :timestamp, :integer
  end

  def down
    change_column :positions, :timestamp, :datetime
  end
end
