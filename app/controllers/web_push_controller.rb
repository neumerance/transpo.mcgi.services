require 'net/http'

class WebPushController < ApplicationController
  def subscribe
    uri = URI("#{WEBPUSH_URL}/subscribe")
    response = Net::HTTP.post_form(uri, params)
    render json: response.body, status: response.code
  end
end
