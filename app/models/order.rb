class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :account_manager

  def set_date!
    self.date = Date.now.utc
  end

  def generate_order_number!
    self.order_id = SecureRandom.urlsafe_base64
  end
end
