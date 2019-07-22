class Customer < ApplicationRecord
  belongs_to :industry
  has_many :orders
end
