class AddOmniauthToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_index :users, [:uid, :provider], unique: true, name: "index_users_on_uid_and_provider"
  end
end
