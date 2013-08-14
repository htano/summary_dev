class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail_addr
      t.boolean :yuko_flg
      t.timestamp :last_login
      t.string :open_id
      t.string :prof_image, {:default => 'no_image.png'}

      t.timestamps
    end

    add_index :users, :name, :unique => true, :name => 'idx_name'
    add_index :users, :open_id, :unique => true, :name => 'idx_openid'
  end
end
