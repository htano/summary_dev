class CreateU011FavoriteUsers < ActiveRecord::Migration
  def change
    create_table :u011_favorite_users do |t|
      t.integer :u010_user_id
      t.integer :favorite_user_id

      t.timestamps
    end
  end
end
