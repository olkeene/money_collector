class CreateCountryCurrencies < ActiveRecord::Migration
  def self.up
    create_table :country_currencies do |t|
      t.belongs_to :country
      t.string     :currency_code
      t.date       :visited_at
      t.text       :notes
    end
  end

  def self.down
    drop_table :country_currencies
  end
end
