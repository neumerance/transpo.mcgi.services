require 'mailgun-ruby'

class RideRequestService
  attr_accessor :ride_request, :client, :rendered_template

  def initialize(ride_request)
    @client = Mailgun::Client.new ENV['MAILGUN_API']
    @ride_request ||= ride_request
  end

  def ride_requested
    client.send_message(
      'mcgi.services',
      mail_params(
        ride_request.passenger.email,
        'Your Ride Has Been Requested <DO NOT REPLY>',
        'ride_request_mailer/ride_requested'
      )
    )
  end

  def notify_drivers
    DriversOnDuty.on_duty.map do |ddo|
      client.send_message(
        'mcgi.services',
        mail_params(
          ddo.driver.email,
          "ATTENTION ALL UNITS! #{ride_request.passenger.name.titleize} is requesting for a ride <DO NOT REPLY>",
          'ride_request_mailer/ride_requested'
        )
      )
    end
  end

  def mail_params(to, subject, template)
    {
      from:     ENV['MAIL_FROM'],
      to:       to,
      subject:  subject,
      html:     render_template(template)
    }
  end

  def render_template(template)
    @rendered_template ||= {}
    @rendered_template[template] ||= ApplicationController.renderer.render(
                                      template: template,
                                      formats: [:html],
                                      assigns: { ride_request: ride_request },
                                      layout: false
                                    )
  end
end
