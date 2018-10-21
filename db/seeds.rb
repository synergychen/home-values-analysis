require "csv"

CSV.foreach("data/zipcodes/new-york.csv", headers: true) do |row|
  city_name = row["city"]
  state = row["state"]
  borough = row["borough"]
  neighborhood = row["neighborhood"]
  zipcode = row["zipcode"]

  city = City.find_or_create_by(name: city_name, state: state)
  area = city.areas.find_or_create_by(
    borough: borough,
    neighborhood: neighborhood,
    zipcode: zipcode
  )
  p "Created / Updated zipcode: #{area.zipcode}, city: #{city.name}"
end
