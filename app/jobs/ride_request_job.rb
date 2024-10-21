class RideRequestJob < ApplicationJob
  queue_as :default

  def perform(ride_request_id:)
    ride_request = RideRequest.find(ride_request_id)
    passenger = Passenger.find(ride_request.passenger_id)
    drivers = DriversOnDuty.on_duty.map do |dod|
      "#{dod.driver.name}#{dod.driver.id}".parameterize
    end.compact

    params = {
      actor: passenger.name.parameterize,
      recipients: drivers,
      message: "#{passenger.name.titleize} is looking for a ride!",
      viewUrl: "http://localhost:3000/ride_requests/#{ride_request.id}"
    }

    response = HTTParty.post(
      "http://webpush:9090/notify",
      body: params.to_json,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end
