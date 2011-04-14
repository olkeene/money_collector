class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string  :name, :code
      t.integer :visited_count, :default => 0
    end
  end

  def self.down
    drop_table :countries
  end
end
