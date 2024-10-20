class CreateDriversOnDuties < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers_on_duties do |t|
      t.references :driver, foreign_key: { to_table: :users }, index: true
      t.integer :seat_capacity
      t.datetime :on_duty_since
      t.datetime :on_duty_until
      t.timestamps
    end
  end
end
