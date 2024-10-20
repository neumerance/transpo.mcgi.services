class ApplicationController < ActionController::Base
  private

  def driver_only_check
    return unless current_user

    raise ActiveRecord::RecordInvalid.new("User must be a driver") unless current_user.driver?
  end

  def passenger_only_check
    return unless current_user

    raise ActiveRecord::RecordInvalid.new("User must be a passenger") unless current_user.passenger?
  end
end
