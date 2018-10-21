module Zillow
  class HomeValue < ApplicationRecord
    self.table_name = "zillow_home_values"

    STATUS_SUCCESS = "success".freeze
    STATUS_FAIL    = "fail".freeze

    scope :succeeded, -> { where(status: STATUS_SUCCESS) }
    scope :failed, -> { where(status: STATUS_FAIL) }

    belongs_to :area, class_name: 'Area'

    def success?
      status == STATUS_SUCCESS
    end

    def fail?
      status == STATUS_FAIL
    end

    def success!
      self.status = STATUS_SUCCESS
    end

    def fail!
      self.status = STATUS_FAIL
    end
  end
end
