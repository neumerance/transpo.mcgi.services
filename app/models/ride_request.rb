class RideRequest < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'
  belongs_to :passenger, class_name: 'User', foreign_key: 'passenger_id'

  enum status: [:pending, :pickedup, :completed, :ended]

  def pickup(driver)
    update(status: :pickedup, driver: driver)
  end

  def completed(driver)
    update(status: :completed, driver: driver)
  end

  def drop!
    update(status: :pending, driver_id: nil)
  end
end
