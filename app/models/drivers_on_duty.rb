class DriversOnDuty < ApplicationRecord
  def on_duty?
    on_duty_until >= DateTime.now
  end
end
