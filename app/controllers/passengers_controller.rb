class PassengersController < ApplicationController
  before_action :set_passenger

  def new; end

  def show; end

  def edit; end

  def update
    if @passenger.update(passenger_params.merge(user_type: :passenger))
      redirect_to ride_requests_path
    else
      render :edit
    end
  end

  private

  def set_passenger
    @passenger ||= Passenger.find(current_user.id)
  end

  def passenger_params
    params.require(:passenger).permit(:name, :phone)
  end
end
