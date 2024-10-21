class RideRequestJob < ApplicationJob
  queue_as :default

  def perform(ride_request_id:)
    ride_request = RideRequest.find(ride_request_id)
    passenger = Passenger.find(ride_request.passenger_id)
    drivers = DriversOnDuty.on_duty.map do |dod|
      dod.driver.name.parameterize
    end.compact

    Knock::Workflows.trigger(
      key: "send-sms-notification",
      actor: passenger.name.parameterize,
      recipients: drivers,
      data: {
        origin: ride_request.origin,
        destination: ride_request.destination,
        pickup_time: ride_request.pickup_time.strftime("%I:%M %p"),
        seats: ride_request.seats,
        contact_number: passenger.phone,
        cta_url: "/ride_requests/#{ride_request.id}",
        priority: 1,
      }
    )
  end
end
