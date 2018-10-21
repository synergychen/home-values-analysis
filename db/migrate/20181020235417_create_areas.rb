class CreateAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|
      t.string :zipcode
      t.integer :city_id

      t.timestamps
    end
  end
end
