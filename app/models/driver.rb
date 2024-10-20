class Driver < User
  default_scope { where(user_type: :driver) }

  has_one :ride_request, -> { with_statuses([:pickingup, :pickedup]) }, foreign_key: 'driver_id'
  has_one :drivers_on_duty, foreign_key: 'driver_id'

  validates :name, :phone, presence: true
  validates :name, :phone, uniqueness: true
end
