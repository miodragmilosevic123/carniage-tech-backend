class Contact < ApplicationRecord
  validates :name, presence: true
  validates :number, presence: true, numericality: { only_integer: true }

  belongs_to :user
end