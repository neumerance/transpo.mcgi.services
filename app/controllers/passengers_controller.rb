class PassengersController < ApplicationController
  def new; end

  def show; end

  def edit; end

  def update
    if current_user.update(passenger_params.merge(user_type: :passenger))
      redirect_to ride_requests_path
    else
      render :edit
    end
  end

  private

  def passenger_params
    params.require(:passenger).permit(:name, :phone)
  end
end
