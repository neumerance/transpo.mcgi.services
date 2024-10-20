class DriversOnDutiesController < ApplicationController
  before_action :authenticate_user!
  before_action :driver_only_check!

  def new
    redirect_to ride_request_path if driver.drivers_on_duties.exists?
    @drivers_on_duty = DriversOnDuty.new
  end

  def create
    @drivers_on_duty = DriversOnDuty.new(drivers_on_duty_params)
    @drivers_on_duty.on_duty_since = DateTime.now

    if @drivers_on_duty.save
      redirect_to :ride_request_path
    else
      render :new
    end
  end

  def destroy
    DriversOnDuty.find(params[:id]).destroy
  end

  private

  def driver
    Driver.find(current_user.id)
  end

  def drivers_on_duty_params
    params.require(:drivers_on_duty).permit(:seat_capacity, :on_duty_until)
  end
end
