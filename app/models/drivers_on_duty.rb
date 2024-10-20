class DriversOnDuty < ApplicationRecord
  belongs_to :driver, class_name: 'User', foreign_key: 'driver_id'
  before_create :set_duty_schedule

  def on_duty?
    on_duty_until >= DateTime.now
  end

  private

  def set_duty_schedule
    self.on_duty_since = DateTime.now
    self.on_duty_until = DateTime.current.change(hour: on_duty_until.hour, min: on_duty_until.min)
  end
end
