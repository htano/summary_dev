class CreateU010Users < ActiveRecord::Migration
  def change
    create_table :u010_users do |t|
      t.integer :user_id
      t.string :user_name
      t.string :mail_addr
      t.boolean :yuko_flg
      t.timestamp :last_login
      t.string :open_id

      t.timestamps
    end

    add_index :u010_users, :user_name, :unique => true, :name => 'idx_user_name'
    add_index :u010_users, :open_id, :unique => true, :name => 'idx_openid'
  end
end
