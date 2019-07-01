class Company < ApplicationRecord
  belongs_to :company_type
  belongs_to :owner
  has_many :contacts
end
