class Driver < User
  default_scope { where(user_type: :driver) }

  has_many :ride_requests, foreign_key: 'driver_id'
  has_one :drivers_on_duty, foreign_key: 'driver_id'

  validates :name, :phone, uniqueness: true
  validate :one_active_duty_per_driver

  private

  def one_active_duty_per_driver
    if drivers_on_duties.exists?
      errors.add(
        :base,
        "Driver can only have one active duty at a time. "
      )
    end
  end
end
