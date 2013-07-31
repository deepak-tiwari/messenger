class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end

    add_index :messages, :from_user_id
    add_index :messages, :to_user_id
    add_index :messages, [:from_user_id, :to_user_id,:created_at], unique: true
  end
end
