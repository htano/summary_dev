class AddKeepLoginIpToUsers < ActiveRecord::Migration
  def change
    add_column :users, :keep_login_ip, :string, :default => nil
  end
end
