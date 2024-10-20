class RideRequest < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'
  belongs_to :passenger, class_name: 'User', foreign_key: 'passenger_id'

  enum status: [:pending, :pickedup, :completed, :ended]
end
