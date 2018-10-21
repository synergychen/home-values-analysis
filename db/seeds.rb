CITY_LIST = [
  { name: "New York", slug: "new-york", state: "ny", zip_start: 10001, zip_end: 11104 }
]

CITY_LIST.each do |city_data|
  city = City.find_or_create_by(
    name: city_data[:name],
    slug: city_data[:slug],
    state: city_data[:state]
  )
  p "Created / Updated city: #{city.name}"
  zipcode_start = city_data[:zip_start]
  zipcode_end = city_data[:zip_end]

  (zipcode_start..zipcode_end).each do |zipcode|
    city.areas.find_or_create_by(zipcode: zipcode)
    p "Created / Updated zipcode: #{zipcode}, city: #{city.name}"
  end
end
