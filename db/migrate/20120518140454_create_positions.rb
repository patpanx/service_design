class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :user_id
      t.decimal :lat
      t.decimal :long
      t.decimal :altitude
      t.decimal :accuracy
      t.decimal :altitude_accuracy
      t.timestamp :timestamp

      t.timestamps
    end
  end
end
