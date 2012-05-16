class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :session_id
      t.integer :owner_id
      t.datetime :timestamp
      t.integer :receiver_id
      t.text :text
      t.string :media
      t.integer :location_id

      t.timestamps
    end
  end
end
