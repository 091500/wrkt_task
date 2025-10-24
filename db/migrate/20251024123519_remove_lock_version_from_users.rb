class RemoveLockVersionFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :lock_version, :integer
  end
end
