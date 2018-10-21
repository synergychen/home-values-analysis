class CreateZillowHomeValues < ActiveRecord::Migration[5.1]
  def change
    create_table :zillow_home_values do |t|
      t.integer :zestimate
      t.decimal :one_year_change
      t.decimal :one_year_forecast
      t.integer :median_list
      t.integer :median_sale
      t.integer :median_rent_list
      t.string :status
      t.integer :area_id

      t.timestamps
    end
  end
end
