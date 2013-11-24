class ChangeFavoriteUsersNotAllowNullFavoriteUserId < ActiveRecord::Migration
  def change
    change_column :favorite_users, :favorite_user_id, :integer, :null => false
  end
end
