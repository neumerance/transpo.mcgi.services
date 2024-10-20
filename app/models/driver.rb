class Driver < User
  default_scope { where(user_type: :driver) }

  has_many :ride_requests, foreign_key: 'driver_id'
end
