require 'net/http'

class WebPushController < ApplicationController
  def subscribe
    uri = URI("http://localhost:3001/subscribe")
    response = Net::HTTP.post_form(uri, JSON.parse(params["subscriptionData"].to_json))
    render json: response.body, status: response.code
  end
end
