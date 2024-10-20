class PassengersController < ApplicationController
  before_action :set_user_type
  before_action :set_passenger

  def new; end

  def show; end

  def edit; end

  def update
    if @passenger.update(passenger_params)
      redirect_to ride_requests_path
    else
      render :edit
    end
  end

  private

  def set_passenger
    @passenger ||= current_user
  end

  def set_user_type
    current_user.user_type = :passenger
  end

  def passenger_params
    params.require(:passenger).permit(:name, :phone)
  end
end
