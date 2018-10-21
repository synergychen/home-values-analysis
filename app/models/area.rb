class Area < ApplicationRecord
  belongs_to :city
  has_many :zillow_home_values, class_name: 'Zillow::HomeValue'
end
