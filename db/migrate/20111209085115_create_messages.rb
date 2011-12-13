class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :user_id
      t.integer :channel_id
      t.integer :to_user

      t.timestamps
    end
  end
end
