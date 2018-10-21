module Zillow
  class HomeValue < ApplicationRecord
    self.table_name = "zillow_home_values"

    STATUS_SUCCESS = "success".freeze
    STATUS_FAIL    = "fail".freeze

    belongs_to :area, class_name: 'Area'

    def success?
      status == STATUS_SUCCESS
    end

    def fail?
      status == STATUS_FAIL
    end
  end
end
