class DriversOnDuty < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'
  before_create :set_duty_schedule
  before_create :one_active_duty_per_driver
  validate :one_active_duty_per_driver
  validates :seat_capacity, :on_duty_until, presence: true

  scope :on_duty, -> () { where("on_duty_until >= ?", Time.zone.now) }

  def on_duty?
    on_duty_until >= Time.zone.now
  end

  def occupied?
    Driver.find(driver.id).ride_request.present?
  end

  private

  def set_duty_schedule
    self.on_duty_since = Time.zone.now
    self.on_duty_until = DateTime.current.change(hour: on_duty_until.hour, min: on_duty_until.min)
  end

  def one_active_duty_per_driver
    if driver.drivers_on_duty.present?
      errors.add(
        :base,
        "Driver can only have one active duty at a time. "
      )
    end
  end
end
