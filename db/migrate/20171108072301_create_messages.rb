class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :sender, null: false
      t.belongs_to :receiver, null: false
      t.text :message
      t.boolean :read, default: false
    end
  end
end
