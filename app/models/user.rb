class User < ApplicationRecord
  enum user_type: [:passenger, :driver]
end
