class DriversController < ApplicationController
  before_action :set_driver

  def show; end

  def edit; end

  def update
    if @driver.update(driver_params.merge(user_type: :driver))
      redirect_to new_drivers_on_duty_path
    else
      render :edit
    end
  end

  private

  def set_driver
    @driver ||= current_user
  end

  def driver_params
    params.require(:driver).permit(:name, :phone)
  end
end
