class CreateRideRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :ride_requests do |t|
      t.references :driver, foreign_key: { to_table: :users }, index: true
      t.references :passenger, foreign_key: { to_table: :users }, index: true
      t.integer :seats, default: 1
      t.string :origin
      t.string :destination
      t.integer :status, default: 0
      t.datetime :pickup_time
      t.timestamps
    end

    add_index :ride_requests, [:driver_id, :passenger_id]
  end
end
