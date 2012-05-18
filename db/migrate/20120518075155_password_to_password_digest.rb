class PasswordToPasswordDigest < ActiveRecord::Migration
  def up
    rename_column :users, :password, :password_digest
  end

  def down
    change_rename :users, :password_digest, :password
  end
end
