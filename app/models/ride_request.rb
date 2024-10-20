class RideRequest < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id', optional: true
  belongs_to :passenger, class_name: 'User', foreign_key: 'passenger_id'

  enum status: [:awaiting, :pickingup, :pickedup, :completed, :ended]

  before_create :set_pickup_time

  validate :one_active_ride_per_passenger

  scope :with_statuses, ->(statuses) { where(status: statuses) }

  def pickup(driver)
    update(status: :pickedup, driver: driver)
  end

  def completed(driver)
    update(status: :completed, driver: driver)
  end

  def drop!
    update(status: :pending, driver_id: nil)
  end

  private

  def set_pickup_time
    self.pickup_time = DateTime.current.change(hour: pickup_time.hour, min: pickup_time.min)
  end

  def one_active_ride_per_passenger
    ride_request = passenger.ride_request
    if ride_request.present? && ride_request.awaiting?
      errors.add(
        :base,
        "Passenger can only have one active ride request at a time. "\
        "Cancel your current ride request if you need to schedule a new one."
      )
    end
  end
end
