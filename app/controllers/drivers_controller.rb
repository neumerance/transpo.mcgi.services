class DriversController < ApplicationController
  def show; end

  def edit; end

  def update
    if current_user.update(driver_params.merge(user_type: :driver))
      redirect_to new_drivers_on_duty_path
    else
      render :edit
    end
  end

  private

  def driver_params
    params.require(:driver).permit(:name, :phone)
  end
end
