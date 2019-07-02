class Tenant < ApplicationRecord
  has_one :owner
  has_many :users, dependent: :destroy
end
