class RideRequestMailer < ApplicationMailer
  default from: 'transpo@mcg.services'

  def ride_requested(ride_request)
    @ride_request = ride_request

    mail(to: @ride_request.passenger.email, subject: 'Your Ride Has Been Requested <DO NOT REPLY>')
  end

  def notify_drivers(ride_request)
    @ride_request = ride_request
    @drivers = DriversOnDuty.on_duty.map { |ddo| ddo.driver.email }

    mail(to: @drivers , subject: "ATTENTION ALL UNITS! #{@ride_request.passenger.name.titleize} is requesting for a ride <DO NOT REPLY>")
  end
end
