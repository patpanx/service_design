class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :owner_id
      t.integer :timeout
      t.integer :forwarding_time

      t.timestamps
    end
  end
end
