class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :account_manager
end
