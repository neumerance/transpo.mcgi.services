namespace :ride_requests do
  desc "This cleansup stale ride requests"
  task cleanup: :environment do
    RideRequestCleanupJob.perform_later
  end
end
