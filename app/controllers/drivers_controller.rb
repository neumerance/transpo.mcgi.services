class DriversController < ApplicationController
  def new
    @driver = Driver.new
  end

  def show
    @driver = Driver.find(params[:id])
  end

  def edit
    @driver = Driver.find(params[:id])
  end

  def create
    @driver = Driver.new(driver_params)

    if @driver.save
      redirect_to new_drivers_on_duty_path
    else
      render :new
    end
  end

  def update
    @driver = Driver.find(params[:id])
    if @driver.update(driver_params)
      redirect_to new_drivers_on_duty_path
    else
      render :edit
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:name, :phone, :email)
  end
end
