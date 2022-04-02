class CreateFilteredBySexes < ActiveRecord::Migration[6.1]
  def change
    create_table :filtered_by_sexes do |t|
      t.integer :male
      t.integer :unisex

      t.timestamps
    end
  end
end
