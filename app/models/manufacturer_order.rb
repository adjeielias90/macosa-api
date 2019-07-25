class ManufacturerOrder < ApplicationRecord
  belongs_to :manufacturer
  belongs_to :order
end
