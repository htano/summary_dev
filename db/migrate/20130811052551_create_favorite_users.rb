class CreateFavoriteUsers < ActiveRecord::Migration
  def change
    create_table :favorite_users do |t|
      t.integer :user_id
      t.integer :favorite_user_id

      t.timestamps
    end
    add_index(:favorite_users, [:user_id, :favorite_user_id], :unique => true)
  end
end
