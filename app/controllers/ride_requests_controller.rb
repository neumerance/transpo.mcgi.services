class RideRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :passenger_only_check!, only: [:new, :create, :destroy]
  before_action :driver_only_check!, only: [:update, :pickup, :completed, :drop]

  def index
    if current_user.driver?
      redirect_to new_drivers_on_duty_path unless driver.drivers_on_duty.present?

      @ride_requests = RideRequest.awaiting
    else
      @ride_requests = RideRequest.where(passenger_id: current_user.id).where.not(status: [:completed, :ended])
    end
  end

  def new
    redirect_to ride_requests_path if passenger.ride_requests.exists?
    @ride_request = RideRequest.new
  end

  def create
    @ride_request = RideRequest.new(create_ride_params)
    @ride_request.passenger = passenger

    if @ride_request.save
      redirect_to ride_requests_path
    else
      render :new
    end
  end

  def pickup
    @ride_request = RideRequest.find(params[:id])
    @ride_request.pickup(driver)
  end

  def completed
    @ride_request = RideRequest.find(params[:id])
    @ride_request.completed(driver)
  end

  def drop
    @ride_request = RideRequest.find(params[:id])
    @ride_request.drop!
  end

  def destroy
    RideRequest.find(params[:id]).destroy
  end

  private

  def driver
    @driver ||= Driver.find(current_user.id)
  end

  def passenger
    @passenger ||= Passenger.find(current_user.id)
  end

  def create_ride_params
    params.require(:ride_request).permit(
      :seats,
      :origin,
      :destination,
      :pickup_time
    )
  end
end
