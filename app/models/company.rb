class Api::V1::Company < ApplicationRecord
  belongs_to :company_type
  belongs_to :owner
end
