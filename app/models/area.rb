class Area < ApplicationRecord
  belongs_to :city
  has_one :zillow_home_value, class_name: 'Zillow::HomeValue'

  validates :zipcode, uniqueness: true

  def borough_slug
    borough.downcase.gsub(" ", "-")
  end
end
