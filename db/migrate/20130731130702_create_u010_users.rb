class CreateU010Users < ActiveRecord::Migration
  def change
    create_table :u010_users do |t|
      t.integer :user_id, :unique => true
      t.string :user_name, :unique => true
      t.string :mail_addr, :unique => true
      t.boolean :yuko_flg
      t.timestamp :last_login
      t.integer :open_id, :unique => true

      t.timestamps
    end
  end
end
