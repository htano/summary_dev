class AddFavoriteUsersConutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :favorite_users_count, :integer
  end
end
