class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :mail_addr
      t.boolean :yuko_flg
      t.timestamp :last_login
      t.timestamp :last_mypage_access
      t.string :open_id
      t.string :prof_image, {:default => 'no_image.png'}
      t.integer :mail_addr_status, {:default => nil}
      t.string :token_uuid, {:default => nil}
      t.timestamp :token_expire, {:default => nil} 
      t.string :full_name, {:default => ''}
      t.text :comment, {:default => ''}
      t.string :site_url, {:default => ''}
      t.boolean :public_flg, {:default => false}

      t.timestamps
    end

    add_index :users, :name, :unique => true, :name => 'idx_name'
    add_index :users, :open_id, :unique => true, :name => 'idx_openid'
  end
end
