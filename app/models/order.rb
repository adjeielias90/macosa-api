class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :account_manager

  def set_date!
    self.reset_sent_at = Time.now.utc
  end

  def generate_order_number!
    self.order_id = SecureRandom.urlsafe_base64
  end
end
