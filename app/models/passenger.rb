class Passenger < User
  default_scope { where(user_type: :passenger) }

  has_one :ride_request, foreign_key: 'passenger_id'

  validates :name, :phone, presence: true
  validates :name, :phone, uniqueness: true
  validate :one_active_ride_per_passenger

  private

  def one_active_ride_per_passenger
    if ride_requests.where(status: [:pending, :pickedup]).exists?
      errors.add(
        :base,
        "Passenger can only have one active ride request at a time. "\
        "Cancel your current ride request if you need to schedule a new one."
      )
    end
  end
end
