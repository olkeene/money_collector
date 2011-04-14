class Country < ActiveRecord::Base
  attr_accessor :buy_all
  
  validate :code, :presence => true

  has_many :country_currencies, :dependent => :destroy

  scope :visited, where("visited_count > 0")

  before_save :process_buy_all

  def visited?
    visited_count > 0
  end
  
  private

  def process_buy_all
    if buy_all == 'true'
      Service.data.each do |d|
        if d[:country_code] == code
          country_currencies.create!(:currency_code => d[:currency_code], :visited_at => Time.now) unless
            country_currencies.exists?(:currency_code => d[:currency_code])
        end
      end
    else
      country_currencies.destroy_all
    end
  end
end
