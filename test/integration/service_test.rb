require 'test_helper'

class ServiceTest < ActiveSupport::TestCase
  context "data" do
    should "has right output format" do
      data = Service.data
      assert data.is_a?(Array)
      assert data.size > 0

      assert data[0].has_key? :country
      assert data[0].has_key? :country_code
      assert data[0].has_key? :currency
      assert data[0].has_key? :currency_code
    end

    should "create countries" do
      Country.destroy_all

      data = Service.data
      assert Country.count == data.collect{|d| d[:country_code] }.uniq.size
    end
  end
end
