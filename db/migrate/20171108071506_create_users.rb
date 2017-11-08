class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.datetime :last_online_at
      t.text :nickname, unique: true
      t.datetime :created_at
    end
  end
end
