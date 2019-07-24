class Order < ApplicationRecord
  belongs_to :customer
  belongs_to :account_manager

  def set_date!
    self.date = Time.now.utc
  end

  def generate_order_number!
    self.order_no = SecureRandom.urlsafe_base64
  end


  # Modify function to check if at least 1 business_unit_order or manifucturer order exists


  # validate :has_sentence_or_painting  # the name of a method we'll define below

  # private # <-- not required, but conventional

  # def has_sentence_or_painting
  #   unless self.sentences.exists? || self.paintings.exists?
  #     # since it's not an error on a single field we add an error to :base
  #     self.errors.add :base, "Must have a Sentence or Painting!"

  #     # (of course you could be much more specific in your handling)
  #   end
  # end










end
