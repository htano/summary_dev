class ChangeFavoriteUsersNotAllowNullUserId < ActiveRecord::Migration
  def change
    change_column :favorite_users, :user_id, :integer, :uniqueness => {:scope => :favorite_user_id}, :null => false
  end
end
