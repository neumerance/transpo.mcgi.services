class Passenger < User
  default_scope { where(user_type: :passenger) }

  has_one :ride_request, -> { with_statuses([:awaiting, :pickingup, :pickedup]) }, foreign_key: 'passenger_id'

  validates :name, :phone, presence: true
  validates :name, :phone, uniqueness: true
end
