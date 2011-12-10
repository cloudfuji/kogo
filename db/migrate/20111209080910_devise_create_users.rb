class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.bushido_authenticatable
      t.trackable

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :locale

      t.timestamps
    end

    add_index :users, :ido_id,                :unique => true
  end

end
