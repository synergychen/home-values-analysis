namespace :zillow do
  desc "Update zillow home values"
  task update_home_values: :environment do
    city = "new york"
    zipcodes = (10001...11104).to_a

    zipcodes.each do |zipcode|
      service = Zillow::HomeValuesService.new city, zipcode
      service.perform

      if service.success?
        Zillow::HomeValue.create
      end
    end
  end
end
