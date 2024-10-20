module ApplicationHelper
  def driver
    @driver ||= Driver.find(current_user.id)
  end

  def passenger
    @passenger ||= Passenger.find(current_user.id)
  end
end
