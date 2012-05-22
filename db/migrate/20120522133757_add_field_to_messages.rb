class AddFieldToMessages < ActiveRecord::Migration

  def up
    remove_column :messages, :media, :string
    add_column :messages, :media_file_name, :string
    add_column :messages, :media_content_type, :string
    add_column :messages, :media_file_size, :integer
    add_column :messages, :media_updated_at, :datetime
  end

  def down
    add_column :messages, :media, :string
    remove_column :messages, :media_file_name
    remove_column :messages, :media_content_type
    remove_column :messages, :media_file_size
    remove_column :messages, :media_updated_at
  end
end

