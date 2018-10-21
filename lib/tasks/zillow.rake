namespace :zillow do
  desc "Update zillow home values"
  task update_home_values: :environment do
    city = City.find_by(name: "New York")

    city.areas.each do |area|
      service = Zillow::HomeValuesService.new city.slug, city.state, area.zipcode
      service.perform

      zillow_home_value = area.zillow_home_value || Zillow::HomeValue.new(area: area)
      if service.success?
        zillow_home_value.success!
        zillow_home_value.update_attributes(service.data)
        p "Successfully fetch city: #{city.name}, zipcode: #{area.zipcode}"
      else
        if !zillow_home_value.persisted? || !zillow_home_value.success?
          zillow_home_value.fail!
          zillow_home_value.save
          p "Failed to fetch city: #{city.name}, zipcode: #{area.zipcode}"
        end
      end

      sleep 3
    end
  end
end
