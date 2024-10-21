module ApplicationHelper
  def driver
    Driver.find_by(id: current_user.id)
  end

  def passenger
    Passenger.find_by(id: current_user.id)
  end
end
