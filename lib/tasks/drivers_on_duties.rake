namespace :drivers_on_duties do
  desc "This cleansup state drivers on duty records"
  task cleanup: :environment do
    DriversOnDutyCleanupJob.perform_later
  end
end
