class RideRequestCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    RideRequest.where("pickup_time < ?", Time.current).where(status: [:awaiting]).update_all(status: :ended)
    RideRequest.where("pickup_time < ?", Time.current).where(status: [:pickingup, :pickedup]).update_all(status: :completed)
  end
end
