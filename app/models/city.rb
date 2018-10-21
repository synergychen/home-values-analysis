class City < ApplicationRecord
  has_many :areas

  validates :name, uniqueness: true

  def slug
    name.downcase.gsub(" ", "-")
  end
end
