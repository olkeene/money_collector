require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  context "process_buy_all" do
    setup do
      @country = Country.create! :code => 'af'
    end

    should "buy all currencies" do
      currencies_count = Service.data.find_all{|d| d[:country_code] == @country.code }.size
      @country.buy_all = 'true'
      @country.save!
      assert @country.country_currencies.count == currencies_count
    end

    should "remove all bought currencies" do
      @country.buy_all = 'true'
      @country.save!

      @country.buy_all = 'false'
      @country.save!
      assert @country.country_currencies.count == 0
    end
  end
end
