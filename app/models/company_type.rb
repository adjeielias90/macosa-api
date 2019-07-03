class CompanyType < ApplicationRecord
  before_save :downcase_typename
  has_many :companies

  def downcase_typename
    self.typename = self.typename.delete('').downcase
  end

  validates :typename, uniqueness: true

end
