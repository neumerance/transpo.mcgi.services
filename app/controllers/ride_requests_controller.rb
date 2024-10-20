class RideRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :passenger_only_check, only: [:new, :create, :destroy]
  before_action :driver_only_check, only: [:update, :pickup, :completed, :drop]

  def index
    if current_user.driver?
      @ride_requests = RideRequest.pending
    else
      @ride_requests = RideRequest.pending.where(passenger_id: current_user.id)
    end
  end

  def new
    @ride_request = RideRequest.new
  end

  def create
    @ride_request = RideRequest.new(create_ride_params)
    @ride_request.passenger = current_user

    if @ride_request.save
      redirect_to ride_requests_path
    else
      render :new
    end
  end

  def pickup
    @ride_request = RideRequest.find(params[:id])
    @ride_request.pickup(current_user)
  end

  def completed
    @ride_request = RideRequest.find(params[:id])
    @ride_request.completed(current_user)
  end

  def drop
    @ride_request = RideRequest.find(params[:id])
    @ride_request.drop!
  end

  def destroy
    RideRequest.find(params[:id]).destroy
  end

  private

  def create_ride_params
    params.require(:ride_request).permit(
      :seats,
      :origin,
      :destination,
      :pickup_time
    )
  end
end
