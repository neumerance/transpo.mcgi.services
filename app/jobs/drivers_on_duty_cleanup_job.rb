class DriversOnDutyCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DriversOnDuty.where("on_duty_until < ?", Time.zone.now).destroy_all
  end
end
