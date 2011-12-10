class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name, :null => false
      t.text :users

      t.timestamps
    end
  end
end
