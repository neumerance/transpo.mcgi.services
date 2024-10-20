class DriversController < ApplicationController
  before_action :set_user_type
  before_action :set_driver

  def show; end

  def edit; end

  def update
    if @driver.update(driver_params)
      redirect_to new_drivers_on_duty_path
    else
      render :edit
    end
  end

  private

  def set_driver
    @driver ||= current_user
  end

  def set_user_type
    current_user.user_type = :driver
  end

  def driver_params
    params.require(:driver).permit(:name, :phone)
  end
end
