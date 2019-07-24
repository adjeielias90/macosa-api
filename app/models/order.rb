class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :account_manager

  def set_date!
    self.date = Date.now.utc
  end
end
