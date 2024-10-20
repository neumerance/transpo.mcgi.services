class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.integer :user_type, default: 2

      t.timestamps
    end
  end
end
