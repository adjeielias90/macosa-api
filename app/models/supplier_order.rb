class SupplierOrder < ApplicationRecord
  belongs_to :order
  belongs_to :manufacturer
  acts_as_paranoid

  def generate_order_number!
    self.supplier_no = SecureRandom.hex(6)
    save
  end

end
