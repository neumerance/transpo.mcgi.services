module ApplicationHelper
  def driver
    Driver.find(current_user.id)
  end

  def passenger
    Passenger.find(current_user.id)
  end
end
