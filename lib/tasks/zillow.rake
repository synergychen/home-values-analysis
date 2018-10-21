namespace :zillow do
  desc "Update zillow data and generate reports"
  task all: :environment do
    Rake::Task["zillow:update_home_values"].execute
    Rake::Task["zillow:export_csv"].execute
  end

  desc "Update zillow home values"
  task update_home_values: :environment do
    City.all.each do |city|
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

        sleep 1
      end
    end
  end

  desc "Export zillow home values"
  task export_csv: :environment do
    Zillow::HomeValuesService.export_csv
  end
end
