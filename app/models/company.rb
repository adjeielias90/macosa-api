class Company < ApplicationRecord
  belongs_to :company_type
  belongs_to :owner

  # remove 'dependent: :destroy' to enforce FK constraint
  has_many :contacts, dependent: :destroy
  has_many :users, dependent: :destroy
end
