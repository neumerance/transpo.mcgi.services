class DriversOnDuty < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'
  before_create :set_duty_schedule

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
end
