class DriversOnDutiesController < ApplicationController
  before_action :authenticate_user!
  before_action :driver_only_check!

  def new
    redirect_to ride_requests_path if driver.drivers_on_duty.present?
    @drivers_on_duty = DriversOnDuty.new
  end

  def create
    @drivers_on_duty = DriversOnDuty.new(drivers_on_duty_params)
    @drivers_on_duty.driver = driver

    if @drivers_on_duty.save
      redirect_to ride_requests_path
    else
      render :new
    end
  end

  def destroy
    DriversOnDuty.find(params[:id]).destroy

    redirect_to root_path
  end

  private

  def driver
    Driver.find(current_user.id)
  end

  def drivers_on_duty_params
    params.require(:drivers_on_duty).permit(:seat_capacity, :on_duty_until)
  end
end
